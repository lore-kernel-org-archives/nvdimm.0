Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940FB53A9
	for <nvdimm@lists.linux.dev>; Thu,  7 Mar 2024 02:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709777433; cv=none; b=KaOuejPry+GmIOcW+JPRmMMiBPzezw5OLkD6nkfjetzFGBNo4e27MgE/OHXOIEoCYprdHkUbMUAdLrJxBRMVjfV44xs1AutU6OHEvDrij0cIVxYm789ntfBY08qrUpDR1ceCcFostCAX4Eibwo71+gc+Bl0Dc/mNkClXpunh9LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709777433; c=relaxed/simple;
	bh=UBOu4TbmRU3NWr5RrQ0LTAQ6ZIkowJ0amcjXmpgsfgY=;
	h=To:From:Subject:Message-ID:Date:MIME-Version:Content-Type; b=NYRaztF797jzXH4/WdMF/YxnlKtT8vg5YoM7pkLNTljQtOER1NaqIaeGe+G5XKe93WdhFH2e/Zk31sYCLPycTfvQwB5r5tmTQ8sJdxX6YRYeDujp6JHyP934qvXONFgWwEAbg0/3lMUDTtH29asyOHK61NuXrvnQzpAAFSMmL1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Tqt4L0KlRz1Q9ft
	for <nvdimm@lists.linux.dev>; Thu,  7 Mar 2024 10:08:02 +0800 (CST)
Received: from kwepemm600013.china.huawei.com (unknown [7.193.23.68])
	by mail.maildlp.com (Postfix) with ESMTPS id 044471402E0
	for <nvdimm@lists.linux.dev>; Thu,  7 Mar 2024 10:10:24 +0800 (CST)
Received: from [10.174.178.46] (10.174.178.46) by
 kwepemm600013.china.huawei.com (7.193.23.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Mar 2024 10:10:23 +0800
To: <nvdimm@lists.linux.dev>
From: Zhihao Cheng <chengzhihao1@huawei.com>
Subject: subscribe
Message-ID: <cc80086c-593d-0b6d-73e4-7ac5c76d4599@huawei.com>
Date: Thu, 7 Mar 2024 10:10:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600013.china.huawei.com (7.193.23.68)

subscribe@lists.linux.dev <mailto:nvdimm+subscribe@lists.linux.dev>

