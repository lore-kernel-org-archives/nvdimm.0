Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
	(using TLSv1.2 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47447C
	for <nvdimm@lists.linux.dev>; Fri,  1 Apr 2022 11:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1648811244; x=1680347244;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PQKYqlplQ+YtuM+4DhzNPUAAGz0mJYlg4m/LCeRhK/E=;
  b=fTRtSo9LJvqVkNTYoqHJR3NrDTUI0JBMF7W2rL1AShMVXjEportNbaTK
   ymj/5jWsP3yesEqW0ZaXCXAxzEUpgs3oT3sf/OEv3Q9fN+hkFNxj8bIuY
   Xu83cfdWZRMYxZOH9Q0vSA+fHU1Bw5eXayPuSmK7b4aOxbnrDglaN6qZF
   0=;
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 01 Apr 2022 04:07:20 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg01-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 04:07:18 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 1 Apr 2022 04:07:18 -0700
Received: from qian (10.80.80.8) by nalasex01a.na.qualcomm.com (10.47.209.196)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 1 Apr 2022
 04:07:14 -0700
Date: Fri, 1 Apr 2022 07:07:12 -0400
From: Qian Cai <quic_qiancai@quicinc.com>
To: Muchun Song <songmuchun@bytedance.com>
CC: Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox
	<willy@infradead.org>, Jan Kara <jack@suse.cz>, Alexander Viro
	<viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>, Yang Shi <shy828301@gmail.com>, "Ralph
 Campbell" <rcampbell@nvidia.com>, Hugh Dickins <hughd@google.com>, Xiyu Yang
	<xiyuyang19@fudan.edu.cn>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>, Ross Zwisler <zwisler@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, linux-fsdevel
	<linux-fsdevel@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, LKML
	<linux-kernel@vger.kernel.org>, Linux Memory Management List
	<linux-mm@kvack.org>, Xiongchun duan <duanxiongchun@bytedance.com>, "Muchun
 Song" <smuchun@gmail.com>
Subject: Re: [PATCH v5 0/6] Fix some bugs related to ramp and dax
Message-ID: <Ykbc4N+Q1CH43CQ/@qian>
References: <20220318074529.5261-1-songmuchun@bytedance.com>
 <YkXPA69iLBDHFtjn@qian>
 <CAMZfGtWFg=khjaHsjeHA24G8DMbjbRYRhGytBHaD7FbORa+iMg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAMZfGtWFg=khjaHsjeHA24G8DMbjbRYRhGytBHaD7FbORa+iMg@mail.gmail.com>
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)

On Fri, Apr 01, 2022 at 11:44:16AM +0800, Muchun Song wrote:
> Thanks for your report. Would you mind providing the .config?

$ make ARCH=arm64 defconfig debug.config
