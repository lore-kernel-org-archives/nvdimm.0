Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2444A29;
	Thu, 20 Feb 2025 00:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740012350; cv=none; b=kEXjBTuBGDbD+J7r/rfzyjNOdyQs4W3RFoALJivJaht4A51ppdlAyqgxJ9+wMjzh6wY95jwAveGvbQ7aKdQGCNnQzSb3/FUmRPGU92hkehVUHVK9Qga3f/e4ztcCekHzMk792onDVEkDRKajTGTGwp4UUCCF5ApxYDoKFmT3Aa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740012350; c=relaxed/simple;
	bh=fdgXB85yE0FhxtaAFhxT9rscVdj5MxhmbDXA116JK/s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EEKSKH+IXvJs0y7+ijfddpfhzTRhjFFEuHz5QnhBwyjSxeIRyTgy9GExFVNdB9yFNpr66JKnrSfUyFOOZSKmT+LdoZbg/l2DRxqrXcyZoGMv0OQKd+lS75b6J90nQq9PoKX+fokLWxtbj+z1y1Gu4claQEbwLhPsgeMAV4x37k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=nKpM7z0S; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="nKpM7z0S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=3lgi6T89V4gN7Bcb2TUw40d2V2iTTOLt79CiL7QSvY4=; b=nKpM7z0Sae8phAiC
	dxyWOOzDWx9WzA0w/d6WAlRGW2M+6RfUU2xUO8A8D4akSO2jQ+HrrSRtwZyuThMrAarnu/b1FzD7G
	+IILXqNJOU/iexVUg8fVTPehhZm9US6Yr7jf6S+aegvL1geRDKQgtU9KGk/ZJvfkAElcWpnD40Wsp
	os+y2UTyF42oApenQmN4fj7h6WU3JziKUCnvq/EmpV8I5asEa71SqMgicAPhZGRZScKsBW0q7cd2+
	k5sjx/daPsv8IV84gU1MRk7vcoRzpjLiZOCQAwIwXWjc44zR9NH53YL3OnpZiM7l0XVf6L43MJCSK
	O/wma++JKhI6nQmbJA==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1tkuh9-00H2o0-0F;
	Thu, 20 Feb 2025 00:45:39 +0000
From: linux@treblig.org
To: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 0/2] nvdimm deadcoding
Date: Thu, 20 Feb 2025 00:45:36 +0000
Message-ID: <20250220004538.84585-1-linux@treblig.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

Hi,
  A couple of nvdimm dead coding patches; they just
remove entirely unused functions.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>


Dr. David Alan Gilbert (2):
  libnvdimm: Remove unused nd_region_conflict
  libnvdimm: Remove unused nd_attach_ndns

 drivers/nvdimm/claim.c       | 11 ----------
 drivers/nvdimm/nd-core.h     |  4 ----
 drivers/nvdimm/region_devs.c | 41 ------------------------------------
 3 files changed, 56 deletions(-)

-- 
2.48.1

