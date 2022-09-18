Received: from tartarus.angband.pl (tartarus.angband.pl [51.83.246.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD4D2568
	for <nvdimm@lists.linux.dev>; Sun, 18 Sep 2022 20:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=angband.pl;
	s=tartarus; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bjHWAmA4F7zQ5P77KhiGhLE/j549LV+hAaG+XmVx1Jg=; b=klWpTcxpXBJStyYHRzHkihVNNG
	Xa05zgABhrvObIjTw2SQG9ORPi+MgsQIDiOV1/1yK6BF+s6ew70E4tpE//dEOXRvOGQ61f7YeFbCH
	Pi2+XmevMnXXlEFUB0H9r3A/OJn2Myxvfgi86HqWgdYHoXDftpO7sjkLHuffmOZQUW1g=;
Received: from localhost ([127.0.0.1] helo=valinor.angband.pl)
	by tartarus.angband.pl with smtp (Exim 4.94.2)
	(envelope-from <kilobyte@valinor.angband.pl>)
	id 1oa0Af-001hch-Ok; Sun, 18 Sep 2022 21:41:41 +0200
Received: (nullmailer pid 24434 invoked by uid 1000);
	Sun, 18 Sep 2022 19:41:41 -0000
From: Adam Borowski <kilobyte@angband.pl>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev
Cc: Helmut Grohne <helmut@subdivi.de>, Adam Borowski <kilobyte@angband.pl>
Subject: [ndctl PATCH] meson: Avoid an unnecessary compiler run test.
Date: Sun, 18 Sep 2022 21:41:33 +0200
Message-Id: <20220918194133.24415-1-kilobyte@angband.pl>
X-Mailer: git-send-email 2.37.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: kilobyte@valinor.angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false

From: Helmut Grohne <helmut@subdivi.de>

Signed-off-by: Helmut Grohne <helmut@subdivi.de>
Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 meson.build | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/meson.build b/meson.build
index 20a646d..70911b1 100644
--- a/meson.build
+++ b/meson.build
@@ -231,19 +231,18 @@ conf.set('ENABLE_DESTRUCTIVE', get_option('destructive').enabled())
 conf.set('ENABLE_LOGGING', get_option('logging').enabled())
 conf.set('ENABLE_DEBUG', get_option('dbg').enabled())
 
-typeof = cc.run('''
-  int main() {
+typeof_code = '''
+  void func() {
     struct {
       char a[16];
     } x;
     typeof(x) y;
 
-    return sizeof(x) == sizeof(y);
+    char static_assert[2 * (sizeof(x) == sizeof(y)) - 1];
   }
   '''
-)
 
-if typeof.compiled() and typeof.returncode() == 1
+if cc.compiles(typeof_code)
   conf.set('HAVE_TYPEOF', 1)
   conf.set('HAVE_STATEMENT_EXPR', 1)
 endif
-- 
2.37.2

