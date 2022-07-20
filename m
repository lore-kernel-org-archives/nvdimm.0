Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D486AA0
	for <nvdimm@lists.linux.dev>; Wed, 20 Jul 2022 17:44:49 +0000 (UTC)
Received: from fraeml703-chm.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Lp2z13197z67x0m;
	Thu, 21 Jul 2022 01:40:13 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml703-chm.china.huawei.com (10.206.15.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Wed, 20 Jul 2022 19:44:46 +0200
Received: from localhost (10.81.205.121) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 20 Jul
 2022 18:44:45 +0100
Date: Wed, 20 Jul 2022 18:44:43 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <hch@lst.de>, <nvdimm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 25/28] cxl/hdm: Commit decoder state to hardware
Message-ID: <20220720184443.00000bda@Huawei.com>
In-Reply-To: <165784338418.1758207.14659830845389904356.stgit@dwillia2-xfh.jf.intel.com>
References: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
	<165784338418.1758207.14659830845389904356.stgit@dwillia2-xfh.jf.intel.com>
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

On Thu, 14 Jul 2022 17:03:04 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> After all the soft validation of the region has completed, convey the
> region configuration to hardware while being careful to commit decoders
> in specification mandated order. In addition to programming the endpoint
> decoder base-address, interleave ways and granularity, the switch
> decoder target lists are also established.
> 
> While the kernel can enforce spec-mandated commit order, it can not
> enforce spec-mandated reset order. For example, the kernel can't stop
> someone from removing an endpoint device that is occupying decoderN in a
> switch decoder where decoderN+1 is also committed. To reset decoderN,
> decoderN+1 must be torn down first. That "tear down the world"
> implementation is saved for a follow-on patch.
> 
> Callback operations are provided for the 'commit' and 'reset'
> operations. While those callbacks may prove useful for CXL accelerators
> (Type-2 devices with memory) the primary motivation is to enable a
> simple way for cxl_test to intercept those operations.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

LGTM
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

