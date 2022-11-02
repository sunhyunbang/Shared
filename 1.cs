//c#
protected virtual void Transfer(object arg) {
    Stream writeStream = null;
    FileStream readStream = null;
    System.Net.HttpWebRequest webRequest = System.Net.HttpWebRequest.Create(task.DestURI) as System.Net.HttpWebRequest; 
    webRequest.Method = "POST";
    webRequest.Accept = "*/*";
    webRequest.UserAgent = "DLNADOC/1.50";
    webRequest.Timeout = System.Threading.Timeout.Infinite; 
    webRequest.KeepAlive = true; 
    webRequest.SendChunked = true; 
    writeStream = webRequest.GetRequestStream(); 
    readStream = new FileStream(task.SourceURI.LocalPath, FileMode.Open, FileAccess.Read, FileShare.Read);

    int count = 0;
    while ((count = readStream.Read(buffer, 0, buffer.Length)) > 0) {
        writeStream.Write(buffer, 0, count);
    } 
    if (readStream != null) {
        try { 
            readStream.Close();
            readStream.Dispose();
        } catch { } 
    }
    
    if (writeStream != null) {
        try { 
            writeStream.Close(); 
            writeStream.Dispose();
        } catch { } 
    } 
} 
출처: https://crystalcube.co.kr/20 [유리상자 속 이야기:티스토리]


protected virtual void Transfer(object arg) {
    Stream writeStream = null; 
    FileStream readStream = null; 
    System.Net.HttpWebRequest webRequest = System.Net.HttpWebRequest.Create(task.DestURI) as System.Net.HttpWebRequest; 
    webRequest.Method = "POST"; 
    webRequest.Accept = "*/*"; 
    webRequest.UserAgent = "DLNADOC/1.50";
    webRequest.Timeout = System.Threading.Timeout.Infinite; 
    webRequest.KeepAlive = true; 
    webRequest.SendChunked = true; 
    writeStream = webRequest.GetRequestStream(); 
    readStream = new FileStream(task.SourceURI.LocalPath, FileMode.Open, FileAccess.Read, FileShare.Read); 
    int count = 0; 
    while ((count = readStream.Read(buffer, 0, buffer.Length)) > 0) {
        writeStream.Write(buffer, 0, count);
    } 
    
    if (readStream != null) { 
        try { 
            readStream.Close(); 
            readStream.Dispose(); 
        } catch { } 
    }
    
    if (writeStream != null) { 
        try { 
            writeStream.Close(); 
            writeStream.Dispose(); 
        } catch { } 
    } 
    
    if (webRequest != null) { 
        try { 
            System.Net.WebResponse response = webRequest.GetResponse(); 
            response.Close(); 
        } catch { } 
    } 
}  
출처: https://crystalcube.co.kr/20 [유리상자 속 이야기:티스토리]

------------------------------------------------------------------------------------------------------------------------------------------------------------


//Java
private static void writeMultiPart(OutputStream out, String jsonMessage, File file, String boundary) throws
		IOException {
		StringBuilder sb = new StringBuilder();
		sb.append("--").append(boundary).append("\r\n");
		sb.append("Content-Disposition:form-data; name=\"message\"\r\n\r\n");
		sb.append(jsonMessage);
		sb.append("\r\n");

		out.write(sb.toString().getBytes("UTF-8"));
		out.flush();

		if (file != null && file.isFile()) {
			out.write(("--" + boundary + "\r\n").getBytes("UTF-8"));
			StringBuilder fileString = new StringBuilder();
			fileString
				.append("Content-Disposition:form-data; name=\"file\"; filename=");
			fileString.append("\"" + file.getName() + "\"\r\n");
			fileString.append("Content-Type: application/octet-stream\r\n\r\n");
			out.write(fileString.toString().getBytes("UTF-8"));
			out.flush();

			try (FileInputStream fis = new FileInputStream(file)) {
				byte[] buffer = new byte[8192];
				int count;
				while ((count = fis.read(buffer)) != -1) {
					out.write(buffer, 0, count);
				}
				out.write("\r\n".getBytes());
			}

			out.write(("--" + boundary + "--\r\n").getBytes("UTF-8"));
		}
		out.flush();
	}