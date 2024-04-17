Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40396657B0
	for <nvdimm@lists.linux.dev>; Wed, 17 Apr 2024 06:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713336457; cv=none; b=jOVhHxCVK+WsMVY6izOTL8fLxHc9vD/il3q8lI1nojx5tOHS2YstptKEgl9SkCMabGPbkruM49s+Rz4oZwuJrAs3EqUKxEgAosS/vbDsRMV/ZMi2IP/tP3k9Cdw1OVDUpUrIOexkXdFczXOZgW2u7tLgCvnkHBujkK/RFEDA2Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713336457; c=relaxed/simple;
	bh=jOeB/Ttfi5E3wbad0Nk5J+qV/IVL/85dayKO6Sw9+jY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=STml2tQXpxHC5mvgD9qesrUp//4p2el02MMrbyoWeAwVaEt7eqHCVjGQf3IOIll8c8puxlETv707L5UMoqL0xznvUlypLopWVK7DI9b4liCpVWIHcLnBNiL8JbJBueUp0Z0sZh2gNlbUse0ZzzLalguTuyAL2OeUSUY2m/b/CLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=s0UARMoQ; arc=none smtp.client-ip=207.54.90.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="s0UARMoQ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1713336454; x=1744872454;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jOeB/Ttfi5E3wbad0Nk5J+qV/IVL/85dayKO6Sw9+jY=;
  b=s0UARMoQUi+o3AbG3xmBMZV4FWEy8bbCvXjj8djplYtWbw1ZDDph+V1O
   JDGK1f20aR9O747hzYT5Monrzxqg0VWwlHVDJIzEJPk35v0Png9NS2i8M
   UI/zBDC56DWn2aN0Upt//IscJ1/dkr7a5Sb/EjY0E4WUnZBrakwJnuvt+
   nb9murvJFWIjXO6WJxwdtGyAkOUBd+Qjyu4LeCt9wMvDue6+UD15qHFXC
   3aqnh0TKZiQzD5n0XlBTdnuLzQIwcUgRiAjfysnFA+k81+PaQVSH/gXPv
   ZZVpYCNgitTV/XPXJL+wlcFl/Jf0kZJObVwG7PfAA1wJyDJLJSPnAFQ+m
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="155713769"
X-IronPort-AV: E=Sophos;i="6.07,208,1708354800"; 
   d="scan'208";a="155713769"
Received: from unknown (HELO oym-r2.gw.nic.fujitsu.com) ([210.162.30.90])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 15:46:23 +0900
Received: from oym-m4.gw.nic.fujitsu.com (oym-nat-oym-m4.gw.nic.fujitsu.com [192.168.87.61])
	by oym-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id C5F27EB341
	for <nvdimm@lists.linux.dev>; Wed, 17 Apr 2024 15:46:20 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by oym-m4.gw.nic.fujitsu.com (Postfix) with ESMTP id EF91AB1BEF
	for <nvdimm@lists.linux.dev>; Wed, 17 Apr 2024 15:46:19 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id 8A57B20097BE8
	for <nvdimm@lists.linux.dev>; Wed, 17 Apr 2024 15:46:19 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.225.88])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id CEA521A000A;
	Wed, 17 Apr 2024 14:46:18 +0800 (CST)
From: Yao Xingtao <yaoxt.fnst@fujitsu.com>
To: dave.jiang@intel.com
Cc: caoqq@fujitsu.com,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	vishal.l.verma@intel.com
Subject: 
Date: Wed, 17 Apr 2024 02:46:22 -0400
Message-Id: <20240417064622.42596-1-yaoxt.fnst@fujitsu.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <170138109724.2882696.123294980050048623.stgit@djiang5-mobl3>
References: <170138109724.2882696.123294980050048623.stgit@djiang5-mobl3>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28326.005
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28326.005
X-TMASE-Result: 10--4.059000-10.000000
X-TMASE-MatchedRID: oLfcbJd25TeCZTEvplyDNL/HywF9D+dAScHI0MnRcnQtferJ/d7Ab4JE
	j47BCr7iP1EDunecK1e7REX8b2FriHAA9eFj9SfYngIgpj8eDcDp+L+93eAIaCP/VFuTOXUTwWQ
	4ihlkof3hPNzjJM2MWGrz/G/ZSbVq+gtHj7OwNO2oWEe3+NERqbI0kWNjmwyqGK0j4vHSPPcn3B
	ssePE7PCvE812QaQynwGC8e6520fKw0PJt06oJaHpaQl5xviY7wxgWdRvK9Un9g+oMf9KM6Q==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0


Hi Dave,
  I have applied this patch in my env, and done a lot of testing, this
feature is currently working fine. 
  But it is not merged into master branch yet, are there any updates
on this feature?

Associated patches:
https://lore.kernel.org/linux-cxl/170112921107.2687457.2741231995154639197.stgit@djiang5-mobl3/
https://lore.kernel.org/linux-cxl/170120423159.2725915.14670830315829916850.stgit@djiang5-mobl3/

Thanks
Xingtao
