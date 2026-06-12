Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D208E36309C
	for <nvdimm@lists.linux.dev>; Fri, 12 Jun 2026 06:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.204.27.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781244271; cv=none; b=i4R6VDFg7+CIXVnkWFcGiTyqilvT6+ZAQbcOhNFtkEwyB6fnzH1TGJFLErkV/ADcLWhqm1ZjwGsv85KGoIpWarnoEN5iZpgYcIA06BFx/cxFDGKJHbBrpbSw2hbHYROirXQAUDoUpzXAzpTZc31oSBkSBQ/0hdZhB7CFfkQkNIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781244271; c=relaxed/simple;
	bh=JR4/NPp6xduf8TZbLaNbp0R8f75Pk6UDMh5YcyCee6Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cGQDQhbMXsOBA6lr3wn/40m1l2oy5FFA8IZYIl9g0leBBVwfzunA0SeAs/vBK5WGEgCrPGabfU44nTTs+ag9DZU6nPEaNLydrLcj6cR4T/PyVHWPJkuy0C7fc2BW0ICSJotrEXpe1g+dd4tKM6tErmDwesQ1Bcn8pZqadYZIhCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn; spf=pass smtp.mailfrom=hygon.cn; arc=none smtp.client-ip=101.204.27.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hygon.cn
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4gc89067rlz1dd8B;
	Fri, 12 Jun 2026 14:04:04 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4gc88x6nQCz1dd8B;
	Fri, 12 Jun 2026 14:04:01 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 777DC7896;
	Fri, 12 Jun 2026 14:03:43 +0800 (CST)
Received: from hsj-2U-Workstation (172.19.20.61) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 12 Jun
 2026 14:03:57 +0800
Date: Fri, 12 Jun 2026 14:03:55 +0800
From: Huang Shijie <huangsj@hygon.cn>
To: Lorenzo Stoakes <ljs@kernel.org>
CC: <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <jack@suse.cz>, <muchun.song@linux.dev>,
	<osalvador@suse.de>, <david@kernel.org>, <surenb@google.com>,
	<mjguzik@gmail.com>, <liam@infradead.org>, <vbabka@kernel.org>,
	<shakeel.butt@linux.dev>, <rppt@kernel.org>, <mhocko@suse.com>,
	<corbet@lwn.net>, <skhan@linuxfoundation.org>, <linux@armlinux.org.uk>,
	<dinguyen@kernel.org>, <schuster.simon@siemens-energy.com>,
	<James.Bottomley@hansenpartnership.com>, <deller@gmx.de>, <djbw@kernel.org>,
	<willy@infradead.org>, <peterz@infradead.org>, <mingo@redhat.com>,
	<acme@kernel.org>, <namhyung@kernel.org>, <mark.rutland@arm.com>,
	<alexander.shishkin@linux.intel.com>, <jolsa@kernel.org>,
	<irogers@google.com>, <adrian.hunter@intel.com>, <james.clark@linaro.org>,
	<mhiramat@kernel.org>, <oleg@redhat.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>, <jannh@google.com>,
	<pfalcato@suse.de>, <riel@surriel.com>, <harry@kernel.org>,
	<will@kernel.org>, <brian.ruley@gehealthcare.com>,
	<rmk+kernel@armlinux.org.uk>, <dave.anglin@bell.net>, <linux-mm@kvack.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-parisc@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-perf-users@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<zhongyuan@hygon.cn>, <fangbaoshun@hygon.cn>, <yingzhiwei@hygon.cn>
Subject: Re: [PATCH v2 1/4] mm: use mapping_mapped to simplify the code
Message-ID: <aiuhS4iyBxx6Kcag@hsj-2U-Workstation>
References: <20260611061915.2354307-1-huangsj@hygon.cn>
 <20260611061915.2354307-2-huangsj@hygon.cn>
 <airZn524Ip8VsWra@lucifer>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <airZn524Ip8VsWra@lucifer>
X-ClientProxiedBy: cncheex06.Hygon.cn (172.23.18.116) To cncheex04.Hygon.cn
 (172.23.18.114)

Hi Lorenzo & Pedro,
On Thu, Jun 11, 2026 at 04:52:54PM +0100, Lorenzo Stoakes wrote:
> On Thu, Jun 11, 2026 at 02:18:57PM +0800, Huang Shijie wrote:
> > Use mapping_mapped() to simplify the code, make
> > the code tidy and clean.
> >
> > Signed-off-by: Huang Shijie <huangsj@hygon.cn>
> 
> Yeah as Pedro said this one could just be sent separately, and I in fact
> suggest you do that :) So:
> 
Thank you Pedro and Lorenzo.
I can send a separate patch later.

Thanks
Huang Shijie

