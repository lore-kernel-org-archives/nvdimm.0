Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B5F01FB3
	for <nvdimm@lists.linux.dev>; Wed, 16 Feb 2022 03:02:30 +0000 (UTC)
IronPort-Data: =?us-ascii?q?A9a23=3AVyhoJaxH54bFJIxjJOt6t+dIxyrEfRIJ4+MujC/?=
 =?us-ascii?q?XYbTApDhwhGNUyWAdWTrVPf+CYWugc9AkPd7lphwGusPUm9ZnHQtv/xmBbVoQ9?=
 =?us-ascii?q?5OdWo7xwmQcns+qBpSaChohtq3yU/GYRCwPZiKa9kfF3oTJ9yEmj/nSHuOkUYY?=
 =?us-ascii?q?oBwgqLeNaYHZ44f5cs75h6mJYqYDR7zKl4bsekeWGULOW82Ic3lYv1k62gEgHU?=
 =?us-ascii?q?MIeF98vlgdWifhj5DcynpSOZX4VDfnZw3DQGuG4EgMmLtsvwo1V/kuBl/ssIti?=
 =?us-ascii?q?j1LjmcEwWWaOUNg+L4pZUc/H6xEEc+WppieBmXBYfQR4/ZzGhhc14zs5c85K2U?=
 =?us-ascii?q?hsBMLDOmfgGTl9TFCQW0ahuoeWefCjl65PJp6HBWz62qxl0N2k6NJMZ9s55G2Z?=
 =?us-ascii?q?L8uYSKSxLZReG78q2y7KTS+9inM0vIcDneoQFtRlIwTjfS/RgXpHHR6TD4MRw3?=
 =?us-ascii?q?TEsi8QIFvHbD+IVayVoahvoYBBVPFoTTpUkk4+Agnj5bi0drVe9prQ+6GuVyxZ?=
 =?us-ascii?q?+uJDrLtbUf9miQcROgl3eomPA4nS/DhwEXPSfwjqt9mmwwOPC9Qv5UYQfUra46?=
 =?us-ascii?q?9ZtmlSYwmFVAxoTPXO/oP+kmguwQN5SNUEQ0jQhoLJ090GxSNT5GRqirxasuh8?=
 =?us-ascii?q?aRsoVEOAg7gyJ4rTb7hzfBWUeSDNFLts8u6ceQT0sy0/Mj93yLSJgvafTSn+H8?=
 =?us-ascii?q?LqQ6zSoNkAowcUqDcMfZVJdpYC9/8do1VSSJuuP2ZWd1rXdcQwcCRjQxMTmu4g?=
 =?us-ascii?q?usA=3D=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3ATw3XBqNG1Rzw+sBcTv2jsMiBIKoaSvp037BL?=
 =?us-ascii?q?7TEUdfUxSKGlfq+V8sjzqiWftN98YhAdcLO7Scy9qBHnhP1ICOAqVN/MYOCMgh?=
 =?us-ascii?q?rLEGgN1+vf6gylMyj/28oY7q14bpV5YeeaMXFKyer8/ym0euxN/OW6?=
X-IronPort-AV: E=Sophos;i="5.88,333,1635177600"; 
   d="scan'208";a="121582272"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 16 Feb 2022 11:02:28 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
	by cn.fujitsu.com (Postfix) with ESMTP id 2F6C64D169D8;
	Wed, 16 Feb 2022 11:02:27 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Wed, 16 Feb 2022 11:02:26 +0800
Received: from [192.168.22.28] (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Wed, 16 Feb 2022 11:02:26 +0800
Message-ID: <905fd72a-d551-4623-f448-89010b752d0e@fujitsu.com>
Date: Wed, 16 Feb 2022 11:02:26 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v10 5/9] fsdax: Introduce dax_load_page()
To: Dan Williams <dan.j.williams@intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs
	<linux-xfs@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM
	<linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Darrick
 J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>, Christoph Hellwig
	<hch@infradead.org>, Jane Chu <jane.chu@oracle.com>, Christoph Hellwig
	<hch@lst.de>
References: <20220127124058.1172422-1-ruansy.fnst@fujitsu.com>
 <20220127124058.1172422-6-ruansy.fnst@fujitsu.com>
 <CAPcyv4jWuWWWBAEesMorK+LL6GVyqf-=VSChdw6P8txtckC=aw@mail.gmail.com>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <CAPcyv4jWuWWWBAEesMorK+LL6GVyqf-=VSChdw6P8txtckC=aw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-yoursite-MailScanner-ID: 2F6C64D169D8.A1823
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No



在 2022/2/16 9:34, Dan Williams 写道:
> On Thu, Jan 27, 2022 at 4:41 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>>
>> The current dax_lock_page() locks dax entry by obtaining mapping and
>> index in page.  To support 1-to-N RMAP in NVDIMM, we need a new function
>> to lock a specific dax entry
> 
> I do not see a call to dax_lock_entry() in this function, what keeps
> this lookup valid after xas_unlock_irq()?

I am not sure if I understood your advice correctly:  You said 
dax_lock_entry() is not necessary in v9[1].  So, I deleted it.

[1]: 
https://lore.kernel.org/linux-xfs/CAPcyv4jVDfpHb1DCW+NLXH2YBgLghCVy8o6wrc02CXx4g-Bv7Q@mail.gmail.com/


--
Thanks,
Ruan.


