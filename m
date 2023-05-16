Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E001427710
	for <nvdimm@lists.linux.dev>; Tue, 16 May 2023 20:14:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCBDC433A0;
	Tue, 16 May 2023 20:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684268076;
	bh=6CLuxrIav2439MrPgOxLsybmU0ZxykMENHio5PB5Xks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PuJ537HFxfcwhdqwCP8FY0Iz+JnIIEcw+QdKeU4PnmNDYL/WVfrqMMCxzuIZ6eXCs
	 3f9dFRNu/A3vXHLgWDe5fvmcRFazgvPMJo+AD0Agor6XUqgoQaPRbLe+Gy3Mvodwvq
	 yZWJh8hpJ2gWwW6Y/LeKSuaYs/6IsH6gxZFhKZnr6dp4c4qK3YEmwu9aymaHj/B9NX
	 p1TIc26HTglrtf9u5RrYB3Fwv9sY0cYNgsigJyLYbqpNN6Wnyjkxo6MFKtzk3Ednsx
	 DWOVIRLCVNHJesogc+ASjuUbKgnQW1B874rgEDwlKV8PWSdMWeLKtBBRwbtmC4Qm99
	 uhmZKCIs1NFeA==
From: Arnd Bergmann <arnd@kernel.org>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans de Goede <hdegoede@redhat.com>,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] libnvdimm: mark 'security_show' static again
Date: Tue, 16 May 2023 22:14:09 +0200
Message-Id: <20230516201415.556858-3-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230516201415.556858-1-arnd@kernel.org>
References: <20230516201415.556858-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The security_show() function was made global and __weak at some
point to allow overriding it. The override was removed later, but
it remains global, which causes a warning about the missing
declaration:

drivers/nvdimm/dimm_devs.c:352:9: error: no previous prototype for 'security_show'

This is also not an appropriate name for a global symbol in the
kernel, so just make it static again.

Fixes: 15a8348707ff ("libnvdimm: Introduce CONFIG_NVDIMM_SECURITY_TEST flag")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/nvdimm/dimm_devs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 957f7c3d17ba..10c3cb6a574a 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -349,7 +349,7 @@ static ssize_t available_slots_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(available_slots);
 
-ssize_t security_show(struct device *dev,
+static ssize_t security_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
-- 
2.39.2

