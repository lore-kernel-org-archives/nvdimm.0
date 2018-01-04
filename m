Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 96D752236BA84
 for <linux-nvdimm@lists.01.org>; Thu,  4 Jan 2018 11:05:38 -0800 (PST)
From: Logan Gunthorpe <logang@deltatee.com>
References: <20180104190137.7654-1-logang@deltatee.com>
 <20180104190137.7654-8-logang@deltatee.com>
Message-ID: <078f4435-22ac-1ff7-0b91-5022e22d126e@deltatee.com>
Date: Thu, 4 Jan 2018 12:08:18 -0700
MIME-Version: 1.0
In-Reply-To: <20180104190137.7654-8-logang@deltatee.com>
Content-Language: en-US
Subject: Re: [PATCH 07/12] nvme-pci: clean up CMB initialization
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>



On 04/01/18 12:01 PM, Logan Gunthorpe wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Refactor the call to nvme_map_cmb, and change the conditions for probing
> for the CMB.  First remove the version check as NVMe TPs always apply
> to earlier versions of the spec as well.  Second check for the whole CMBSZ
> register for support of the CMB feature instead of just the size field
> inside of it to simplify the code a bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Oops, I forgot:

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
