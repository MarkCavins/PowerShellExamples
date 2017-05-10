###################################################################
#
#    Copyright (c) Microsoft Corporation. All rights reserved.
#    THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF
#    ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
#    IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
#    PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
#
###################################################################

#
# Some information relates to pre-released product which may be substantially modified before it's commercially released. 
# Microsoft makes no warranties, express or implied, with respect to the information provided here.
# You may copy and use this report solely for your internal, reference purposes.
#

<#
.Description
Generates HTML from a raw Windows MDM Diagnostic Report XML

.SYNOPSIS
Generates HTML from a raw Windows MDM Diagnostic Report XML

.EXAMPLE
mdmReportGenerator.ps1 c:\MdmRawDiagnostics.xml C:\mdmFormattedReport.html
#>

#param(
#    [Parameter(Mandatory=$true)][string]$inputXmlFilename,
#    [Parameter(Mandatory=$true)][string]$outputHtmlFilename
#)

$inputXmlFilename = "C:\Users\Public\Documents\MDMDiagnostics\MDMDiagReport.xml"
$outputHtmlFilename = "C:\Temp\out.html"

#
#  HTML related strings
#

# HTML to display on top of the page.
$htmlTopOfPage = "<b>MDM Diagnostic information</b>`n" +
                 "<p><b>Note: Some information relates to pre-released product which may be substantially modified before it's commercially released. `n" +
                 "Microsoft makes no warranties, express or implied, with respect to the information provided here.`n" +
                 "You may copy and use this report solely for your internal, reference purposes.</b>`n" +
                 "<h1>Configuration Information</h1>`n"

# CSS to make policies table show different color every line, making it much easier to read.
$cssForTable = "<style type=""text/css"">`n" +
               "tr:nth-child(even) {`n"  +
               "background-color: #D0D0D0;`n"  +
               "}`n"  +
               "</style>`n"

# The $format* variables are used to provide human readable strings for various fields instead of raw PS1 variable names.
$formatConfigSource = @{name = 'Configuration Source Id(s)'; expression={ [pscustomobject]$_.configSource } }
$formatEnrollment = @{name = 'ID'; expression={$_.enrollmentId} }
$formatConfigSource = @{name = 'ConfigSource(s)'; expression={ [pscustomobject]$_.configSource } }


#
# Dot source the routines that will do heavy lifting in parsing for us.
#
Import-module $PSScriptRoot\mdmDiagnoseHelpers.psm1

#
# Load the XML and call routines that return PowerShell objects that are easier to manipulate than raw XML.
#
[xml]$mdmDiagnostics = Open-MDMDiagnosticXml($inputXmlFilename)
$enrollments         = Get-MDMDiagnosticEnrollments($mdmDiagnostics)
$policies            = Get-MDMDiagnosticsPolicies($mdmDiagnostics)

#
# Generate reports in HTML off of returned data
#
$htmlEnrollment = $null

#
# Spit out information about each "configuration sourc", internally called an enrollment.
# Configuration sources/enrollments include traditional MDM enrollments but also capture info about Active Sync, Provisioning Packages, etc.
#
foreach ($enrollment in $enrollments)
{
    # Print out basic enrollment information that all enrollments will have.
    $htmlEnrollHeader = ("<h2>Configuration Source={0}</h2>" -f $enrollment.enrollmentInfo.enrollmentType)
    $htmlBasicInfo = $enrollment.enrollmentInfo | Select-Object -Property $formatEnrollment, EnrollmentState | ConvertTo-Html -fragment -As List
    $htmlEnrollment += $htmlEnrollHeader + $htmlBasicInfo 

    # Print out device management account information for this enrollment, if present.  Only output what are the most interesting fields.
    $deviceManagementAccount = $enrollment.deviceManagementAccount
    if ($deviceManagementAccount -ne $NULL)
    {
        $htmlEnrollment += "<h3>Device Management Account</h3>"
        $htmlEnrollment += $deviceManagementAccount | Select-Object -Property AccountUID, Flags, OMADMProtocolVersion | ConvertTo-Html -Fragment -as List
    }

    # Determine resources associated with this config source, namely applications / Wi-Fi / VPN / etc. that IT management authority creates for it.
    $resourcesForFormatting = @()
    foreach ($resourceForTarget in $enrollment.resources)
    {
        foreach ($resource in $resourceForTarget.resources)
        {
            $resourcesForFormatting += [pscustomobject]@{target=$resourceForTarget.resourceTarget;resource=$resource}
        }
    }

    # Output the resources to HTML.
    if ($resourcesForFormatting -ne $NULL)
    {
        $htmlEnrollment += "<h3>Resource Information</h3>"
        $htmlEnrollment += $resourcesForFormatting | ConvertTo-Html -Fragment
    }
}

#
# Generate information about policies set on the device.
# We filter out "Knobs" area as these are only used for internal Windows components, are very verbose, and not generally useful to IT.
#
$htmlPolicy = $policies |? {$_.area -ne "knobs" } | `
    Select-Object -Property Area,PolicyName,DefaultValue,currentValue,policyScope,$formatConfigSource | `
    ConvertTo-Html -fragment

#
# Output the HTML based on the fragments we've built up thus far.
#
ConvertTo-Html `
   -Title "MDM Diagnostics Report" `
   -Body "$cssForTable $htmlTopOfPage $htmlEnrollment <h1>Policy Information</h1><h2>General Policies</h2>$htmlPolicy" | `
   Out-File $outputHtmlFilename


Remove-Module mdmDiagnoseHelpers

Get-Content $outputHtmlFilename

# SIG # Begin signature block
# MIIiBAYJKoZIhvcNAQcCoIIh9TCCIfECAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDlBY7Dpwbpqcw3
# jXlgmJWIyoriR6pNuxEnIweXz2qpj6CCC4MwggULMIID86ADAgECAhMzAAAA79iH
# LjWjgoovAAAAAADvMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTAwHhcNMTUxMDI4MjAzMTI0WhcNMTcwMTI4MjAzMTI0WjCBgzEL
# MAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1v
# bmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjENMAsGA1UECxMETU9Q
# UjEeMBwGA1UEAxMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMIIBIjANBgkqhkiG9w0B
# AQEFAAOCAQ8AMIIBCgKCAQEAsnQT+NXms1KQcT07+BB+BkFRes2c/eV561AB08/w
# SaqDxZAuVptI2FcegPjO8TA71haQw11MHJM640o88K0K29UzC+4F30/28wNlHXd5
# r1VkGTEGFkCgGyEXJpuD6Vprc8V/6XEZszxW1naAYwK/rEcwt/zh4mQ1wytrnwxZ
# JTlGNsBwHI8X2bRV6mosyRw33U4THhMj7QQynJ8KMvSS0fClejLht4b/cUtjidsP
# GONCRBqb3OXBAGvL/o1U3/m4+vkvuImJHIemAh99PoGqjYNNndVfwPlkceGFYTs0
# bu1UbUjD09rQ009+zf8+VjgGhGDUCinvywJW9MACWeyePwIDAQABo4IBejCCAXYw
# HwYDVR0lBBgwFgYIKwYBBQUHAwMGCisGAQQBgjc9BgEwHQYDVR0OBBYEFIqP7430
# LDUEdK29mulUZUdNnwWfMFEGA1UdEQRKMEikRjBEMQ0wCwYDVQQLEwRNT1BSMTMw
# MQYDVQQFEyozODA3NithZDU4YTM4MS0zMzQzLTRkZDctODgzMy0wZGU4M2Q0MWY1
# ZjAwHwYDVR0jBBgwFoAU5vxfe7siAFjkck619CF0IzLm76wwVgYDVR0fBE8wTTBL
# oEmgR4ZFaHR0cDovL2NybC5taWNyb3NvZnQuY29tL3BraS9jcmwvcHJvZHVjdHMv
# TWljQ29kU2lnUENBXzIwMTAtMDctMDYuY3JsMFoGCCsGAQUFBwEBBE4wTDBKBggr
# BgEFBQcwAoY+aHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWND
# b2RTaWdQQ0FfMjAxMC0wNy0wNi5jcnQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0B
# AQsFAAOCAQEA566WAfa9tPNs+TR4gx85fE/W0zxrH766J2iLy/f2RvgXSBx5rk6N
# 6ff8edBKjIqoFsX4jBYpu/afeIsbqdxj107jAc7cXuO++Kb5VJxAT4Zyc8CFnXLl
# l2qDLozDm+PX8vASdjd84RFxMNPpBrKzxpAwLdAYZskvPHPQvE77bikUZaxoqqGu
# yXN+Rh5NC7e01U+th2tNEyQQsJuLU40OT64NYrIi5yNExQW3lm5bkpumy/XvZxw3
# BayBpMCL51vFo4ozPOcvZB0rcaaFGTULRzvN8fJHk8RkjTcRGerKO+rfNPDwfPBW
# fS3C5SVzWhqBCi44SEIU/H93BtkwtV+9QDCCBnAwggRYoAMCAQICCmEMUkwAAAAA
# AAMwDQYJKoZIhvcNAQELBQAwgYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNo
# aW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29y
# cG9yYXRpb24xMjAwBgNVBAMTKU1pY3Jvc29mdCBSb290IENlcnRpZmljYXRlIEF1
# dGhvcml0eSAyMDEwMB4XDTEwMDcwNjIwNDAxN1oXDTI1MDcwNjIwNTAxN1owfjEL
# MAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1v
# bmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UEAxMfTWlj
# cm9zb2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAxMDCCASIwDQYJKoZIhvcNAQEBBQAD
# ggEPADCCAQoCggEBAOkOZFB5Z7XE4/0JAEyelKz3VmjqRNjPxVhPqaV2fG1FutM5
# krSkHvn5ZYLkF9KP/UScCOhlk84sVYS/fQjjLiuoQSsYt6JLbklMaxUH3tHSwoke
# cZTNtX9LtK8I2MyI1msXlDqTziY/7Ob+NJhX1R1dSfayKi7VhbtZP/iQtCuDdMor
# sztG4/BGScEXZlTJHL0dxFViV3L4Z7klIDTeXaallV6rKIDN1bKe5QO1Y9OyFMjB
# yIomCll/B+z/Du2AEjVMEqa+Ulv1ptrgiwtId9aFR9UQucboqu6Lai0FXGDGtCpb
# nCMcX0XjGhQebzfLGTOAaolNo2pmY3iT1TDPlR8CAwEAAaOCAeMwggHfMBAGCSsG
# AQQBgjcVAQQDAgEAMB0GA1UdDgQWBBTm/F97uyIAWORyTrX0IXQjMubvrDAZBgkr
# BgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUw
# AwEB/zAfBgNVHSMEGDAWgBTV9lbLj+iiXGJo0T2UkFvXzpoYxDBWBgNVHR8ETzBN
# MEugSaBHhkVodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2NybC9wcm9kdWN0
# cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcmwwWgYIKwYBBQUHAQEETjBMMEoG
# CCsGAQUFBzAChj5odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRzL01p
# Y1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNydDCBnQYDVR0gBIGVMIGSMIGPBgkrBgEE
# AYI3LgMwgYEwPQYIKwYBBQUHAgEWMWh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9Q
# S0kvZG9jcy9DUFMvZGVmYXVsdC5odG0wQAYIKwYBBQUHAgIwNB4yIB0ATABlAGcA
# YQBsAF8AUABvAGwAaQBjAHkAXwBTAHQAYQB0AGUAbQBlAG4AdAAuIB0wDQYJKoZI
# hvcNAQELBQADggIBABp071dPKXvEFoV4uFDTIvwJnayCl/g0/yosl5US5eS/z7+T
# yOM0qduBuNweAL7SNW+v5X95lXflAtTx69jNTh4bYaLCWiMa8IyoYlFFZwjjPzwe
# k/gwhRfIOUCm1w6zISnlpaFpjCKTzHSY56FHQ/JTrMAPMGl//tIlIG1vYdPfB9XZ
# cgAsaYZ2PVHbpjlIyTdhbQfdUxnLp9Zhwr/ig6sP4GubldZ9KFGwiUpRpJpsyLcf
# ShoOaanX3MF+0Ulwqratu3JHYxf6ptaipobsqBBEm2O2smmJBsdGhnoYP+jFHSHV
# e/kCIy3FQcu/HUzIFu+xnH/8IktJim4V46Z/dlvRU3mRhZ3V0ts9czXzPK5UslJH
# asCqE5XSjhHamWdeMoz7N4XR3HWFnIfGWleFwr/dDY+Mmy3rtO7PJ9O1Xmn6pBYE
# AackZ3PPTU+23gVWl3r36VJN9HcFT4XG2Avxju1CCdENduMjVngiJja+yrGMbqod
# 5IXaRzNij6TJkTNfcR5Ar5hlySLoQiElihwtYNk3iUGJKhYP12E8lGhgUu/WR5mg
# gEDuFYF3PpzgUxgaUB04lZseZjMTJzkXeIc2zk7DX7L1PUdTtuDl2wthPSrXkizO
# N1o+QEIxpB8QCMJWnL8kXVECnWp50hfT2sGUjgd7JXFEqwZq5tTG3yOalnXFMYIV
# 1zCCFdMCAQEwgZUwfjELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
# EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
# bjEoMCYGA1UEAxMfTWljcm9zb2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAxMAITMwAA
# AO/Yhy41o4KKLwAAAAAA7zANBglghkgBZQMEAgEFAKCBxjAZBgkqhkiG9w0BCQMx
# DAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkq
# hkiG9w0BCQQxIgQgc13fcrEng3f++zuf0Ejy4MR8ZIQFWOh9UF+iig2DDs8wWgYK
# KwYBBAGCNwIBDDFMMEqgJIAiAE0AaQBjAHIAbwBzAG8AZgB0ACAAVwBpAG4AZABv
# AHcAc6EigCBodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vd2luZG93czANBgkqhkiG
# 9w0BAQEFAASCAQBTMR9Dn3l27MxotTgBWN0txygdlNjEp3lnlix383nqLxv297kk
# J5TfaIo1XdenXdBJ0evYZEnHjTKT9FGT32MbS2Y0S0NIrciC2zYxkf4IUqYmIMU2
# op8Rq2QCVLD5wBYBLCJ5bVaznpl+hQav4u9hd8FNIG51N0j1PJuV5jxmoAhReE0Z
# /5I0CYgZbwDW28PAPTfSBPqg7VK1Mm7fT47NhXEnyhOSSJmKQWCD9gvpWe8cypJO
# V+eywii+mzhaUtWFLo5gPe7QckTW8SvJ35u5eRPMr82NNgO4JHKen66Cu0aek+BQ
# rxWxm5z+epgdmjfJYY+dNr5YOsI9nwRrwt9NoYITSTCCE0UGCisGAQQBgjcDAwEx
# ghM1MIITMQYJKoZIhvcNAQcCoIITIjCCEx4CAQMxDzANBglghkgBZQMEAgEFADCC
# AT0GCyqGSIb3DQEJEAEEoIIBLASCASgwggEkAgEBBgorBgEEAYRZCgMBMDEwDQYJ
# YIZIAWUDBAIBBQAEIOaI52G5JthZfW6SawQUQ5xH080v2wAhZcQlNJSZI6A4AgZW
# q3c5ag0YEzIwMTYwMjE4MTUyMDMzLjU1N1owBwIBAYACAfSggbmkgbYwgbMxCzAJ
# BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25k
# MR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xDTALBgNVBAsTBE1PUFIx
# JzAlBgNVBAsTHm5DaXBoZXIgRFNFIEVTTjpCMUI3LUY2N0YtRkVDMjElMCMGA1UE
# AxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2VydmljZaCCDswwggZxMIIEWaADAgEC
# AgphCYEqAAAAAAACMA0GCSqGSIb3DQEBCwUAMIGIMQswCQYDVQQGEwJVUzETMBEG
# A1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWlj
# cm9zb2Z0IENvcnBvcmF0aW9uMTIwMAYDVQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0
# aWZpY2F0ZSBBdXRob3JpdHkgMjAxMDAeFw0xMDA3MDEyMTM2NTVaFw0yNTA3MDEy
# MTQ2NTVaMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYD
# VQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAk
# BgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMIIBIjANBgkqhkiG
# 9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqR0NvHcRijog7PwTl/X6f2mUa3RUENWlCgCC
# hfvtfGhLLF/Fw+Vhwna3PmYrW/AVUycEMR9BGxqVHc4JE458YTBZsTBED/FgiIRU
# QwzXTbg4CLNC3ZOs1nMwVyaCo0UN0Or1R4HNvyRgMlhgRvJYR4YyhB50YWeRX4FU
# sc+TTJLBxKZd0WETbijGGvmGgLvfYfxGwScdJGcSchohiq9LZIlQYrFd/XcfPfBX
# day9ikJNQFHRD5wGPmd/9WbAA5ZEfu/QS/1u5ZrKsajyeioKMfDaTgaRtogINeh4
# HLDpmc085y9Euqf03GS9pAHBIAmTeM38vMDJRF1eFpwBBU8iTQIDAQABo4IB5jCC
# AeIwEAYJKwYBBAGCNxUBBAMCAQAwHQYDVR0OBBYEFNVjOlyKMZDzQ3t8RhvFM2ha
# hW1VMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsGA1UdDwQEAwIBhjAPBgNV
# HRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFNX2VsuP6KJcYmjRPZSQW9fOmhjEMFYG
# A1UdHwRPME0wS6BJoEeGRWh0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3Js
# L3Byb2R1Y3RzL01pY1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNybDBaBggrBgEFBQcB
# AQROMEwwSgYIKwYBBQUHMAKGPmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kv
# Y2VydHMvTWljUm9vQ2VyQXV0XzIwMTAtMDYtMjMuY3J0MIGgBgNVHSABAf8EgZUw
# gZIwgY8GCSsGAQQBgjcuAzCBgTA9BggrBgEFBQcCARYxaHR0cDovL3d3dy5taWNy
# b3NvZnQuY29tL1BLSS9kb2NzL0NQUy9kZWZhdWx0Lmh0bTBABggrBgEFBQcCAjA0
# HjIgHQBMAGUAZwBhAGwAXwBQAG8AbABpAGMAeQBfAFMAdABhAHQAZQBtAGUAbgB0
# AC4gHTANBgkqhkiG9w0BAQsFAAOCAgEAB+aIUQ3ixuCYP4FxAz2do6Ehb7Prpsz1
# Mb7PBeKp/vpXbRkws8LFZslq3/Xn8Hi9x6ieJeP5vO1rVFcIK1GCRBL7uVOMzPRg
# Eop2zEBAQZvcXBf/XPleFzWYJFZLdO9CEMivv3/Gf/I3fVo/HPKZeUqRUgCvOA8X
# 9S95gWXZqbVr5MfO9sp6AG9LMEQkIjzP7QOllo9ZKby2/QThcJ8ySif9Va8v/rbl
# jjO7Yl+a21dA6fHOmWaQjP9qYn/dxUoLkSbiOewZSnFjnXshbcOco6I8+n99lmqQ
# eKZt0uGc+R38ONiU9MalCpaGpL2eGq4EQoO4tYCbIjggtSXlZOz39L9+Y1klD3ou
# OVd2onGqBooPiRa6YacRy5rYDkeagMXQzafQ732D8OE7cQnfXXSYIghh2rBQHm+9
# 8eEA3+cxB6STOvdlR3jo+KhIq/fecn5ha293qYHLpwmsObvsxsvYgrRyzR30uIUB
# HoD7G4kqVDmyW9rIDVWZeodzOwjmmC3qjeAzLhIp9cAvVCch98isTtoouLGp25ay
# p0Kiyc8ZQU3ghvkqmqMRZjDTu3QyS99je/WZii8bxyGvWbWu3EQ8l1Bx16HSxVXj
# ad5XwdHeMMD9zOZN+w2/XU/pnR4ZOC+8z1gFLu8NoFA12u8JJxzVs341Hgi62jbb
# 01+P3nSISRIwggTaMIIDwqADAgECAhMzAAAAbX3/fSV3KVnJAAAAAABtMA0GCSqG
# SIb3DQEBCwUAMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
# DgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24x
# JjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMB4XDTE1MTAw
# NzE4MTczMFoXDTE3MDEwNzE4MTczMFowgbMxCzAJBgNVBAYTAlVTMRMwEQYDVQQI
# EwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3Nv
# ZnQgQ29ycG9yYXRpb24xDTALBgNVBAsTBE1PUFIxJzAlBgNVBAsTHm5DaXBoZXIg
# RFNFIEVTTjpCMUI3LUY2N0YtRkVDMjElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUt
# U3RhbXAgU2VydmljZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAL7G
# XDXRx9QzdBHJqSl7KsPXaAGPJ8dMehA/027zzpQnqYjNyuA0eF5KqdVpx8KBrpHA
# 5BeY7yJ9N9Nvtti3ydu+LWBDZRYXrQcWl85fQXPo+ZK6xHzqNyCe7Ys18nfwKIb3
# OSrwSLQ43nVKQeHeu+BLfN+ny/hsss7bDTXCJqPGcWJTaqMUGqo/CFKv+6ygOqJL
# OWuSETjJ46enxzVD2486fkFCiG+OfcuOpzaupDKAfxOrVaUnStAbiLpWakRYs0Nh
# OHYqjk+1vMOW5nSwkV8Wrbxf4EmQj4rQeDQ+m7lkFGlwaWBNqowNYdDDm/YdS0pI
# AoFZZA65TdI8JgxT3wsCAwEAAaOCARswggEXMB0GA1UdDgQWBBTo9jFxY/RnYcII
# OS+MaOm1iESdVjAfBgNVHSMEGDAWgBTVYzpcijGQ80N7fEYbxTNoWoVtVTBWBgNV
# HR8ETzBNMEugSaBHhkVodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2NybC9w
# cm9kdWN0cy9NaWNUaW1TdGFQQ0FfMjAxMC0wNy0wMS5jcmwwWgYIKwYBBQUHAQEE
# TjBMMEoGCCsGAQUFBzAChj5odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2Nl
# cnRzL01pY1RpbVN0YVBDQV8yMDEwLTA3LTAxLmNydDAMBgNVHRMBAf8EAjAAMBMG
# A1UdJQQMMAoGCCsGAQUFBwMIMA0GCSqGSIb3DQEBCwUAA4IBAQBUZeNCPRQrRSZ8
# MMSQWPFzYa9M07Oa7wk0+B3rzpDo3r7KzOSkzoVFXE6BRBOPBRyGsmF8R4b9J/BT
# OXRAes7OcTPUYP+UVJ/LFICHmAzGLysjnTyWzhhlnf9BEXzAp7vbzyyGE+WTZSgz
# ZyB7HC18iAwxgzeYWJQXrymUqRM5PUerOUafnJh9Jt2BiSgVXzloixFp6hC54Zna
# HMkqXnuZTSC/0aul5vjpHvgq6B85okesJfiIXNkqWkbQgWV2G/fcX3AfhzSh3Wxp
# FqP4Vl+YNp+AVTJncBPARwNYHe4bU4uaaYDyscD2GF0rFvNq+HoyDUh4eTy0QUsp
# cx+QUr+7oYIDdTCCAl0CAQEwgeOhgbmkgbYwgbMxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xDTALBgNVBAsTBE1PUFIxJzAlBgNVBAsTHm5DaXBo
# ZXIgRFNFIEVTTjpCMUI3LUY2N0YtRkVDMjElMCMGA1UEAxMcTWljcm9zb2Z0IFRp
# bWUtU3RhbXAgU2VydmljZaIlCgEBMAkGBSsOAwIaBQADFQCNRVFvBeDk8mnqrBrL
# Qv5xgrr0NKCBwjCBv6SBvDCBuTELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
# bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jw
# b3JhdGlvbjENMAsGA1UECxMETU9QUjEnMCUGA1UECxMebkNpcGhlciBOVFMgRVNO
# OjRERTktMEM1RS0zRTA5MSswKQYDVQQDEyJNaWNyb3NvZnQgVGltZSBTb3VyY2Ug
# TWFzdGVyIENsb2NrMA0GCSqGSIb3DQEBBQUAAgUA2m/N8DAiGA8yMDE2MDIxODA0
# NTgyNFoYDzIwMTYwMjE5MDQ1ODI0WjBzMDkGCisGAQQBhFkKBAExKzApMAoCBQDa
# b83wAgEAMAYCAQACAQcwBwIBAAICGiQwCgIFANpxH3ACAQAwNgYKKwYBBAGEWQoE
# AjEoMCYwDAYKKwYBBAGEWQoDAaAKMAgCAQACAxbjYKEKMAgCAQACAwehIDANBgkq
# hkiG9w0BAQUFAAOCAQEAuDLeocbGLw2lbEX9xjwqziz0qyCKQwL6l8U0JCEmb0+m
# yg1ke61yKYx14cTiycyA2fFaWraSuqEeB3ktczFafVokGrc14rORdqXyVfbH5RCj
# QRC6mcQSXd0WGUm3Ka5qBvmUiyyM9Lb82PB+HLQ1SWPY54TRinmvxvBmqIu8Iq2l
# EF5epzyQ+MDtnarBKIgFdOfxBdTjWySug2dnr28iA+TFzhprzqex674/o3pQF+0q
# B986xxgZODEfMXYnO145yuYdsSOJsw8z13Cv9+yZwZRzTJFgtDRL1Tb3qdH/fX8L
# 37SVtfh8yTU1s4vNFkN6Xjg2oqDMzCpTMwEzEnh2HzGCAvUwggLxAgEBMIGTMHwx
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1p
# Y3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAAbX3/fSV3KVnJAAAAAABt
# MA0GCWCGSAFlAwQCAQUAoIIBMjAaBgkqhkiG9w0BCQMxDQYLKoZIhvcNAQkQAQQw
# LwYJKoZIhvcNAQkEMSIEICaAiyqCuMG6fqY5CFpUv98OLjD7mfITG0bkTxk2g0WM
# MIHiBgsqhkiG9w0BCRACDDGB0jCBzzCBzDCBsQQUjUVRbwXg5PJp6qway0L+cYK6
# 9DQwgZgwgYCkfjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQ
# MA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9u
# MSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAG19
# /30ldylZyQAAAAAAbTAWBBSq+ek7H+1762kEQ+Rd6N7vwUc1BTANBgkqhkiG9w0B
# AQsFAASCAQBfeZpec02DaVyo7Qt4hMKS1fO6gd0yjqiPVZ/+rWlVrVZN50LI8/Xq
# Y3SyWpf3ccbDzxu2qL/1EwXhMELU5mnfFM5ShUz8Rt8tDYivx65pTBFn/QhAOIC4
# ddt6CU7QVQWMGhKTprPFtzldDCyD9r35pB/DJCXVQFicymAUVkIb7bRRBtSlpkiR
# 4ANMwz9LnsBGJsAHll6aji8MmC1Vuu0bG6eqHFEdjQ4rnix13H4MugHgAlvohNye
# 8a8qGF2u7AcNpSw/ULzDMLImUSxwlX3mpmFoiqYnik0a1dXPYoW3g8skEjJJthd5
# 13bDMfvHokbc0H7a17uUKygYZn8BEEKp
# SIG # End signature block
