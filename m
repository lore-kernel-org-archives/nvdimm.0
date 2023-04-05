Received: from mail1.bemta34.messagelabs.com (mail1.bemta34.messagelabs.com [195.245.231.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6CF63AB
	for <nvdimm@lists.linux.dev>; Wed,  5 Apr 2023 15:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
	s=170520fj; t=1680707069; i=@fujitsu.com;
	bh=yZprX28JRaN3ebbozlJY+aRU/V39DcwaRbaIl4/8bfw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=a1cl0iRxuwpswDd37PA5UmpvsiAAxK4J/k5rXcPWJ7HO/Z3p0D1A6AKIYaJOfA9Xm
	 lR8j6FVDXn6nU1YImz9bB4y0fBAZeYbnq53ZGzYaLQWT0NHhV1y5Q/OcJbFLaHvSBb
	 EZMlqrMTnnzlj+m1rjZkbji699lFzKU30/RzOaOVVIApFRNc/NdOqUyBEz0hqoLsog
	 SqNH4KQ3c3WOb6LDN0zrCG4LYmqZwtL3XrthQdW/eRmsj6NhqsLRZgSPVG7mymhSeg
	 IiLo9pDXLvNu+oF+pZuOhJojpDQ7Adn/y3i/Z2gK47ORHXZAi4cSmqINtbyYoaGCgn
	 FBmeVWpxeLcBQ==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRWlGSWpSXmKPExsViZ8OxWfdvr26
  KwY3NqhYrf/xhdWD0eLF5JmMAYxRrZl5SfkUCa0bvkifMBc+ZK3q7tzM1ME5j7mLk4hASOMco
  MfP9FhYI5yCTxKN9Lxm7GDmBnH2MEk/6rUBsNgE1iZ3TX7KA2CICMhIX7kxiBbGZBVQkHm56x
  gxiCwvYSdyZcQGol4ODBSg+57w9SJhXwFHi4Py9YK0SAgoSUx6+Z4aIC0qcnPmEBWKMhMTBFy
  +YIWoUJdqW/GOHsCskGqcfYoKw1SSuntvEPIGRfxaS9llI2hcwMq1iNC1OLSpLLdK10Esqykz
  PKMlNzMzRS6zSTdRLLdUtTy0u0TXSSywv1kstLtYrrsxNzknRy0st2cQIDMSUYrXHOxi39v3V
  O8QoycGkJMo7V0UnRYgvKT+lMiOxOCO+qDQntfgQowwHh5IE76ZO3RQhwaLU9NSKtMwcYFTAp
  CU4eJREeFtB0rzFBYm5xZnpEKlTjIpS4rzVIAkBkERGaR5cGywSLzHKSgnzMjIwMAjxFKQW5W
  aWoMq/YhTnYFQS5hXvBprCk5lXAjf9FdBiJqDFtv46IItLEhFSUg1MGYefxFs52DE/2tz7y3V
  f0da182s2BBdmiy1kXCmddsHtMd+fbv0QN5bzuTffs6/coMjTks5+8yW7qcmylcsUjRJzVFXs
  HkxcmXLuwM+NKj36c5cJph8L9v972lrmzqbDE4VTtkkuCj/Hwn58Z5Pri2Bpr5/Fp1/PqF14q
  lV3rfKNaf1Xpi2/zf9MP2Htonpjn8ATjc/Erviq7GeqXTD19c7i1j0VYjcl+z7pr5+Tb7TQ4p
  7UE+3eJ9vkit7l1Die57z8VWG/058bFSskVZnaf71x/PZC5EmMz36pwyl372R4+M22PFl2zVP
  8zAPOs2Lvlpdsjls9R6T2W/UL/jup9gUWkokVQo7L5m+oWnLTXYmlOCPRUIu5qDgRAC+Psqw/
  AwAA
X-Env-Sender: yangx.jy@fujitsu.com
X-Msg-Ref: server-23.tower-548.messagelabs.com!1680707069!282317!1
X-Originating-IP: [62.60.8.179]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received:
X-StarScan-Version: 9.104.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 10090 invoked from network); 5 Apr 2023 15:04:29 -0000
Received: from unknown (HELO n03ukasimr04.n03.fujitsu.local) (62.60.8.179)
  by server-23.tower-548.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 5 Apr 2023 15:04:29 -0000
Received: from n03ukasimr04.n03.fujitsu.local (localhost [127.0.0.1])
	by n03ukasimr04.n03.fujitsu.local (Postfix) with ESMTP id 5533F173
	for <nvdimm@lists.linux.dev>; Wed,  5 Apr 2023 16:04:29 +0100 (BST)
Received: from R01UKEXCASM121.r01.fujitsu.local (R01UKEXCASM121 [10.183.43.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by n03ukasimr04.n03.fujitsu.local (Postfix) with ESMTPS id 49058142
	for <nvdimm@lists.linux.dev>; Wed,  5 Apr 2023 16:04:29 +0100 (BST)
Received: from c869d9130833.localdomain (10.167.215.54) by
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173) with Microsoft SMTP Server
 (TLS) id 15.0.1497.42; Wed, 5 Apr 2023 16:04:27 +0100
From: Xiao Yang <yangx.jy@fujitsu.com>
To: <nvdimm@lists.linux.dev>
CC: Xiao Yang <yangx.jy@fujitsu.com>
Subject: [PATCH ndctl] test/security.sh: Replace cxl with $CXL
Date: Wed, 5 Apr 2023 15:04:20 +0000
Message-ID: <1680707060-54-1-git-send-email-yangx.jy@fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.215.54]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM121.r01.fujitsu.local (10.183.43.173)
X-Virus-Scanned: ClamAV using ClamSMTP

Try to avoid the "cxl: command not found" error when
cxl command is not installed to $PATH.

Signed-off-by: Xiao Yang <yangx.jy@fujitsu.com>
---
 test/security.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/security.sh b/test/security.sh
index fb04aa6..4713288 100755
--- a/test/security.sh
+++ b/test/security.sh
@@ -225,7 +225,7 @@ if [ "$uid" -ne 0 ]; then
 fi
 
 modprobe "$KMOD_TEST"
-cxl list
+$CXL list
 setup
 check_prereq "keyctl"
 rc=1
-- 
2.37.3

