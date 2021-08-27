Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 391423FC6
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 13:38:51 +0000 (UTC)
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3A0Zw3S622jUW+pS94gmV1wAqjBI4kLtp133Aq?=
 =?us-ascii?q?2lEZdPU1SL39qynKppkmPHDP5gr5J0tLpTntAsi9qBDnhPtICOsqTNSftWDd0Q?=
 =?us-ascii?q?PGEGgI1/qB/9SPIU3D398Y/aJhXow7M9foEGV95PyQ3CCIV/om3/mLmZrFudvj?=
X-IronPort-AV: E=Sophos;i="5.84,356,1620662400"; 
   d="scan'208";a="113571592"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 27 Aug 2021 21:38:50 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
	by cn.fujitsu.com (Postfix) with ESMTP id E69214D0DC67;
	Fri, 27 Aug 2021 21:38:48 +0800 (CST)
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Fri, 27 Aug 2021 21:38:48 +0800
Received: from [192.168.122.212] (10.167.226.45) by
 G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Fri, 27 Aug 2021 21:38:49 +0800
Subject: Re: RDMA/rpma + fsdax(ext4) was broken since 36f30e486d
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, Yishai Hadas <yishaih@nvidia.com>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"yangx.jy@fujitsu.com" <yangx.jy@fujitsu.com>
References: <8b2514bb-1d4b-48bb-a666-85e6804fbac0@cn.fujitsu.com>
 <68169bc5-075f-8260-eedc-80fdf4b0accd@cn.fujitsu.com>
 <20210806014559.GM543798@ziepe.ca>
 <b5e6c4cd-8842-59ef-c089-2802057f3202@cn.fujitsu.com>
 <10c4bead-c778-8794-f916-80bf7ba3a56b@fujitsu.com>
 <20210827121034.GG1200268@ziepe.ca>
 <d276eeda-7f30-6c91-24cd-a40916fcc4c8@cn.fujitsu.com>
 <20210827131657.GI1200268@ziepe.ca>
From: "Li, Zhijian" <lizhijian@cn.fujitsu.com>
Message-ID: <1e26aa53-a76a-ffd3-f1f4-1c678dceee75@cn.fujitsu.com>
Date: Fri, 27 Aug 2021 21:38:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20210827131657.GI1200268@ziepe.ca>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-yoursite-MailScanner-ID: E69214D0DC67.AB0CB
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lizhijian@fujitsu.com
X-Spam-Status: No


on 2021/8/27 21:16, Jason Gunthorpe wrote:
> On Fri, Aug 27, 2021 at 09:05:21PM +0800, Li, Zhijian wrote:
>
> Yes, can you send a proper patch and include the mm mailing list?

Of course, my pleasure

Thanks



