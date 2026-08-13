Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B975FDA7
	for <nvdimm@lists.linux.dev>; Thu, 13 Aug 2026 15:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786633875; cv=none; b=NJkRTo0wDblr4d1wm1ukbKurL4I/Q1U0ie3Fg2YDqgxNK/Iuzpw87CDr9K8xF6zfP4YcrehKuOvdh+SKeo2aeFxHncPdhMz8z5ewy9CEJkSF7l7s2JX45RjqeN/jj3k9udIvuYDyMHOeT5Fl+ToaG4zcIxXzHT6GsaBTZ6VA0NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786633875; c=relaxed/simple;
	bh=EOHknXKR03tLn6shY7J3WMfMv6mpknYWTz0pPDrdGl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QIRy12qHd5kc/RRJ8qlzdwyoBXTOqaESfj/Otf8F56FJWM52TDVdFbXDbj35gNHksmfrQWNlyylrQhMqiLd/BdS1oIcJq6iYBgJrIo1JarhBajGjvCt7XfyRQkCJO60r65Vaia8Bt+LDtYdK1zxpOs+IOXSXnkhozPj8Lga/4wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-01 (Coremail) with SMTP id qwCowADnu++P3n1qNB55BQ--.55902S2;
	Thu, 13 Aug 2026 23:11:11 +0800 (CST)
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
Subject: [PATCH v2 1/5] ACPI: NFIT: validate subtable extents before dispatch
Date: Thu, 13 Aug 2026 23:11:11 +0800
Message-ID: <20260813151111.18434-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260813150948.17239-1-pengpeng@iscas.ac.cn>
References: <20260813150948.17239-1-pengpeng@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowADnu++P3n1qNB55BQ--.55902S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tw1rAFW7Gr15Zr1kKFyDZFb_yoW8AF47p3
	WUKa4ayrs8GFsFvw17Aa1FvFy5tws5AFy7K348A34q9w15G3W8JFy8KFy2qas5Jrs5CF4a
	vF4ktFy5AF4kZr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9j14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxa
	n2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
	AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
	17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
	IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4l
	IxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvf
	C2KfnxnUUI43ZEXa7VUbtxhJUUUUU==
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

add_table() checks only that the subtable cursor is before the end of
the NFIT before reading the two-field subtable header. A cursor with
fewer than sizeof(struct acpi_nfit_header) bytes remaining therefore
makes the header read cross the mapped table.

The function also advances by the firmware-provided length without
checking that the advertised subtable fits in the enclosing NFIT. A
malformed length can move the parser beyond the table and make the next
iteration read unrelated memory.

Require a complete header and bind the advertised length to both the
header size and the bytes remaining in the NFIT before dispatching the
subtable.

Fixes: b94d5230d06e ("libnvdimm, nfit: initial libnvdimm infrastructure and NFIT support")
Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/acpi/nfit/core.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index cb771d9cadb2..4428adb6a1ab 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -963,14 +963,18 @@ static void *add_table(struct acpi_nfit_desc *acpi_desc,
 	struct device *dev = acpi_desc->dev;
 	struct acpi_nfit_header *hdr;
 	void *err = ERR_PTR(-ENOMEM);
+	size_t table_len;
 
 	if (table >= end)
 		return NULL;
+	table_len = end - table;
+	if (table_len < sizeof(*hdr))
+		return NULL;
 
 	hdr = table;
-	if (!hdr->length) {
-		dev_warn(dev, "found a zero length table '%d' parsing nfit\n",
-			hdr->type);
+	if (hdr->length < sizeof(*hdr) || hdr->length > table_len) {
+		dev_warn(dev, "invalid table length %u for type %u parsing nfit\n",
+			 hdr->length, hdr->type);
 		return NULL;
 	}
 
-- 
2.50.1 (Apple Git-155)

