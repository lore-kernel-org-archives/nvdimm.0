Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BDF6AA0
	for <nvdimm@lists.linux.dev>; Wed, 20 Jul 2022 18:12:17 +0000 (UTC)
Received: from fraeml708-chm.china.huawei.com (unknown [172.18.147.206])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Lp3bz5mgHz67Y4M;
	Thu, 21 Jul 2022 02:08:47 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml708-chm.china.huawei.com (10.206.15.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 20 Jul 2022 20:12:14 +0200
Received: from localhost (10.81.205.121) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 20 Jul
 2022 19:12:13 +0100
Date: Wed, 20 Jul 2022 19:12:11 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, David Hildenbrand <david@redhat.com>, "Tony
 Luck" <tony.luck@intel.com>, Jason Gunthorpe <jgg@nvidia.com>, Ben Widawsky
	<bwidawsk@kernel.org>, Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Matthew Wilcox <willy@infradead.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, <nvdimm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 00/28] CXL PMEM Region Provisioning
Message-ID: <20220720191211.00000c86@Huawei.com>
In-Reply-To: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
References: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.81.205.121]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected



Hi Dan,

As I mentioned in one of my reviews I'd love to run a bunch of test
cases against this, but won't get to that until sometime in August.
For some of those tests on QEMU I'll need to add some minor features
(multiple HDM decoder support and handling of skip for example).

However, my limited testing of v1 was looking good and I doesn't seem
like there were any fundamental changes.

So personally I'd be happy with this going in this cycle and getting
additional testing later if you and anyone else who comments feels
that's the way to go.

Thanks,

Jonathan

