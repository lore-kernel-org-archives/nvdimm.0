Received: from imap4.hz.codethink.co.uk (imap4.hz.codethink.co.uk [188.40.203.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E0139FCB5;
	Mon, 22 Jun 2026 14:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.40.203.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782138024; cv=none; b=hP4wrTy81qk0DCHykBTysD6LCtXVst+65/Df4ihif0IQS2xxlHz2KCO1EOhgGGtKcFZea/Y/pR1Q+6frhhcDvKJz2aaWORtZqr7YGUTG2z/BUgnaUSa23CkJ3T8uPvGi6yKoZsG1AXpOiA76w1ona30cB0/WqmjoY5smU6u/yjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782138024; c=relaxed/simple;
	bh=qlLkUmrvDYjzBBNhgS2BF+24kswyJ09+xu3rFxgxSs8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dk/OjcZfY69Ix8jwo0hBKu4RYVYsoLpRZnFQgYszTMOCxcFftmAKaBdMQ2mSZVjYiGAmursjw2pH8raUtvHT42kGyXEogBFqt8MPeLUcjfcyfM1PLzBr8oTSSAm4AoXcaxiHw7Q7/SLNn5ri+PvWDMdGODchxj+ukjm9ssniEdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codethink.co.uk; spf=pass smtp.mailfrom=codethink.com; dkim=pass (2048-bit key) header.d=codethink.co.uk header.i=@codethink.co.uk header.b=L93AByjF; arc=none smtp.client-ip=188.40.203.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codethink.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codethink.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codethink.co.uk header.i=@codethink.co.uk header.b="L93AByjF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=codethink.co.uk; s=imap4-20230908; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:In-Reply-To:
	References; bh=SAGU7MNHeA/X609lu5EfA+C8tzcDwDunln14yzh107g=; b=L93AByjFc4vGGQ
	YLks3JJIUIOHeSLK2BVPfcg2Qlvq1fpIWEWejTLtj0fWDIFgZxV+GqKvRlwZfkxPuIlCjBzV7ORGi
	1PV5cIqZa8mGNJTn/Rhi+i00GbS+TgGuO/rT8Z7tWtVTkdK8OycaynrPPD+VUA13yeZy+58dGNiHm
	Ai8adOoX9xIFo2I7wDKB5LqTudzTfW2kHvdY6uD8cUs8TuvCGwBECuALDVkxtNVoPLim1NyuweS6R
	GltL/edi+3UCTjDbANRRE7oLYGPJuhOlZguojjpN/pV5M+QELO/ACxu0d7nwgfbRF2sRlOktX5MNj
	LZW/Yj2paklK7lBxyzbQ==;
Received: from [167.98.27.226] (helo=rainbowdash)
	by imap4.hz.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1wbfVV-00EpHs-Dz; Mon, 22 Jun 2026 15:20:13 +0100
Received: from ben by rainbowdash with local (Exim 4.99.4)
	(envelope-from <ben@rainbowdash>)
	id 1wbfVV-000000023rz-0OcG;
	Mon, 22 Jun 2026 15:20:13 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH] nvdimm/btt: add endian conversion in dev_err in btt_log_read
Date: Mon, 22 Jun 2026 15:20:11 +0100
Message-Id: <20260622142011.491522-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.37.2.352.g3c44437643
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: srv_ts003@codethink.com

The dev_err() call in btt_log_read() is passing a seq value
into dev_err() which is a __le32 without any conversion.

Fix the following (prototype) sparse warnings:
drivers/nvdimm/btt.c:342:17: warning: incorrect type in argument 5 (different base types)
drivers/nvdimm/btt.c:342:17:    expected int
drivers/nvdimm/btt.c:342:17:    got restricted __le32 [usertype] seq
drivers/nvdimm/btt.c:342:17: warning: incorrect type in argument 6 (different base types)
drivers/nvdimm/btt.c:342:17:    expected int
drivers/nvdimm/btt.c:342:17:    got restricted __le32 [usertype] seq

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 drivers/nvdimm/btt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 7e1112960d7f..e9d548442884 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -341,8 +341,9 @@ static int btt_log_read(struct arena_info *arena, u32 lane,
 	if (old_ent < 0 || old_ent > 1) {
 		dev_err(to_dev(arena),
 				"log corruption (%d): lane %d seq [%d, %d]\n",
-				old_ent, lane, log.ent[arena->log_index[0]].seq,
-				log.ent[arena->log_index[1]].seq);
+				old_ent, lane,
+				le32_to_cpu(log.ent[arena->log_index[0]].seq),
+				le32_to_cpu(log.ent[arena->log_index[1]].seq));
 		/* TODO set error state? */
 		return -EIO;
 	}
-- 
2.37.2.352.g3c44437643

