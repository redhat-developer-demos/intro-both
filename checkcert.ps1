# Define the server and port
$server = "registry.fedoraproject.org"
$port = 443

# Create a TCP connection to the server
$tcpClient = New-Object System.Net.Sockets.TcpClient
$tcpClient.Connect($server, $port)

# Get the network stream
$networkStream = $tcpClient.GetStream()

# Create an SSL stream
$sslStream = New-Object System.Net.Security.SslStream($networkStream, $false, ({$true}))

# Authenticate the SSL stream
$sslStream.AuthenticateAsClient($server)

# Get the certificate
$certificate = $sslStream.RemoteCertificate

# Close the streams and TCP connection
$sslStream.Close()
$networkStream.Close()
$tcpClient.Close()

# Display the certificate details
$certificateDetails = New-Object PSObject -Property @{
    Subject = $certificate.Subject
    Issuer = $certificate.Issuer
    Thumbprint = $certificate.Thumbprint
    NotBefore = $certificate.GetEffectiveDateString()
    NotAfter = $certificate.GetExpirationDateString()
}

$certificateDetails | Format-List
