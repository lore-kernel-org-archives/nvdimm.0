Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB99484236
	for <nvdimm@lists.linux.dev>; Thu, 13 Aug 2026 15:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786633795; cv=none; b=qFTbs/Xv5wAFhoPkc468PuFP8ng9Z7dsGBkj2jDWfgIFtxp+ravZ1lwkOeShcXJsD7ionF//mFpUmoWDzlgUI3vlJZfFMgwt5IYdm3qwmiXzef2KaSAbidyjBZgh9iSWdLYiZEcpjSXYCyaaC2jCHas/fjjPh0nX9UQ0XR8jkZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786633795; c=relaxed/simple;
	bh=4fTqmbW/Ir1kfvekNBcHHdO6gaMAAD/9ejt8y9ZjxnA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HsDXc+gBbd6MnbaUZRIFNbn4JRDDmIctoGZ2uhVYB0G4CEzfB330HWOixHYji7LMxf+YIG5kBbF6jN3OG5k3YvbI9DBEQWiH6hzhBVUT0zSFejsTf1VzMvM9sBL2sw3OoX9gxHexoRVLR7OJ7gJlxVBj9Q+PpP/RoZXWu1QmJfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-01 (Coremail) with SMTP id qwCowAAn+u093n1qWAt5BQ--.55707S2;
	Thu, 13 Aug 2026 23:09:50 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Dan Williams <djbw@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Jeff Moyer <jmoyer@redhat.com>,
	Ross Zwisler <zwisler@kernel.org>,
	nvdimm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [PATCH v2 0/5] ACPI: NFIT: harden subtable extent validation
Date: Thu, 13 Aug 2026 23:09:48 +0800
Message-ID: <20260813150948.17239-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAAn+u093n1qWAt5BQ--.55707S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Ary3tryUtF1rtFy8Gw48Zwb_yoW8AFy8pF
	WrG343GF4kJF47A343Aa10qa45u395JFZxWasxG348Z3Wa9w18GFyIkFyjqFy7WryfG3Wa
	9F4jvr97CFWDZ37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9j14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxa
	n2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
	AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
	17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
	IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4l
	IxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvf
	C2KfnxnUUI43ZEXa7VUb_Ma5UUUUU==
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

NFIT parsing has several independent extent contracts: the outer table
must contain each advertised subtable, and variable or versioned records
must fit inside that subtable.  The original patch mixed those contracts
and also derived the SPA structure length from the location-cookie-valid
flag.

Split the checks by record type.  Patch 1 validates the generic subtable
header and outer extent.  Patch 2 accepts both defined SPA layouts while
treating the cookie flag as a validity bit, not a size selector.  Patches
3 and 4 validate the variable arrays and the control-region extent.
Patch 5 bounds the 32-bit capability mask without rejecting future
firmware that advertises a higher capability index.

Changes since v1:
https://lore.kernel.org/all/20260722041701.21078-1-pengpeng@iscas.ac.cn/
- split the generic and type-specific contracts into separate patches
- handle both 56-byte and 64-byte SPA structures
- add the control-region extent check identified during review
- clamp the implemented capability mask instead of rejecting future bits
- describe the exact fields protected by each check

The series was reviewed statically against the current tree. I did not
run an NFIT firmware fault-injection test.

Pengpeng Hou (5):
  ACPI: NFIT: validate subtable extents before dispatch
  ACPI: NFIT: accept SPA structures with an unused location cookie
  ACPI: NFIT: validate interleave and flush array extents
  ACPI: NFIT: validate control region extent
  ACPI: NFIT: bound the platform capability mask

 drivers/acpi/nfit/core.c | 77 ++++++++++++++++++++++++++++++++--------
 1 file changed, 62 insertions(+), 15 deletions(-)

base-commit: f5bbbfec59b4e2fb7520a91de3df8a6174325d6a

-- 
2.50.1 (Apple Git-155)

