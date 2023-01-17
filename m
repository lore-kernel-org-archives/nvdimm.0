Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3119C1FA7
	for <nvdimm@lists.linux.dev>; Tue, 17 Jan 2023 07:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=MhCz0DYhkBpeZ2LhatDbZv+uac7wK5egApOQnTI0j3Q=; b=vjqbSLUasVSaVp5r9lJdtk51nW
	/XzbuOAorBRDopTJd0af4WkekyISs4nUHojIAeYLF8BB4w8LUUvorSnTO00qN+/M8XVkUgsW7UNS9
	FGDUcrRF3OlI0h9hsKF0Fpq3A2MVdO/qZLOki9kLEa0cO2VA29arQowkUpV1a2z4LQ5zfUMF8+q0h
	aUjMjYaj617Ue6d7XpAwcd/v5mLn7o4BBEbDRdestIqncLdp6qS+nxTdeZbg60l5RyMGMSYC2Sxy8
	OXqpQTWPzM6stzbXiSIjhVeJ1ftcH4rLpAG+hORVWuSATLHIpsj52Whqp+LPM/gLD+J3DZZDl8eRH
	J+V7Z2PQ==;
Received: from [2601:1c2:d80:3110::9307] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pHfze-00D7NS-1j; Tue, 17 Jan 2023 07:02:50 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	nvdimm@lists.linux.dev
Subject: [PATCH] dax: super.c: fix kernel-doc bad line warning
Date: Mon, 16 Jan 2023 23:02:49 -0800
Message-Id: <20230117070249.31934-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.39.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert an empty line to " *" to avoid a kernel-doc warning:

drivers/dax/super.c:478: warning: bad line: 

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: nvdimm@lists.linux.dev
---
 drivers/dax/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -- a/drivers/dax/super.c b/drivers/dax/super.c
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -475,7 +475,7 @@ EXPORT_SYMBOL_GPL(put_dax);
 /**
  * dax_holder() - obtain the holder of a dax device
  * @dax_dev: a dax_device instance
-
+ *
  * Return: the holder's data which represents the holder if registered,
  * otherwize NULL.
  */
