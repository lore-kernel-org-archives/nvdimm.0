Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4930336B
	for <nvdimm@lists.linux.dev>; Sat, 20 May 2023 00:48:51 +0000 (UTC)
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
	by vmicros1.altlinux.org (Postfix) with ESMTP id A35F072C8D3
	for <nvdimm@lists.linux.dev>; Sat, 20 May 2023 03:41:10 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
	id 8EBF67CFDD8; Sat, 20 May 2023 03:41:10 +0300 (IDT)
Date: Sat, 20 May 2023 03:41:10 +0300
From: "Dmitry V. Levin" <ldv@strace.io>
To: nvdimm@lists.linux.dev
Subject: [PATCH ndctl] daxctl: fix warning reported by udevadm verify
Message-ID: <20230520004110.GA1677@altlinux.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Fix the following warning reported by udevadm verify:

daxctl/90-daxctl-device.rules:3 Whitespace after comma is expected.
daxctl/90-daxctl-device.rules: udev rules check failed

Signed-off-by: Dmitry V. Levin <ldv@strace.io>
---
 daxctl/90-daxctl-device.rules | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/daxctl/90-daxctl-device.rules b/daxctl/90-daxctl-device.rules
index e02e7ec..fcf94c8 100644
--- a/daxctl/90-daxctl-device.rules
+++ b/daxctl/90-daxctl-device.rules
@@ -1,3 +1,3 @@
-ACTION=="add", SUBSYSTEM=="dax", TAG+="systemd",\
-  PROGRAM="/usr/bin/systemd-escape -p --template=daxdev-reconfigure@.service $env{DEVNAME}",\
+ACTION=="add", SUBSYSTEM=="dax", TAG+="systemd", \
+  PROGRAM="/usr/bin/systemd-escape -p --template=daxdev-reconfigure@.service $env{DEVNAME}", \
   ENV{SYSTEMD_WANTS}="%c"
-- 
ldv
