Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DF50121A0480E
 for <linux-nvdimm@lists.01.org>; Tue, 18 Apr 2017 08:44:56 -0700 (PDT)
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
 <1492121135-4437-6-git-send-email-logang@deltatee.com>
 <20170418064427.r5ewu3p66p2zwdru@phenom.ffwll.local>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <303094a1-15e0-de95-5157-493a6da039bc@deltatee.com>
Date: Tue, 18 Apr 2017 09:44:43 -0600
MIME-Version: 1.0
In-Reply-To: <20170418064427.r5ewu3p66p2zwdru@phenom.ffwll.local>
Subject: Re: [PATCH 05/22] drm/i915: Make use of the new sg_map helper function
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Matthew Wilcox <mawilcox@microsoft.com>, Sumit Semwal <sumit.semwal@linaro.org>, Ming Lin <ming.l@ssi.samsung.com>, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, intel-gfx@lists.freedesktop.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-nvme@lists.infradead.org, linux-nvdimm@lists.01.org, linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org, open-iscsi@googlegroups.com, megaraidlinux.pdl@broadcom.com, sparmaintainer@unisys.com, devel@driverdev.osuosl.org, target-devel@vger.kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, Steve Wise <swise@opengridcomputing.com>, Stephen Bates <sbates@raithlin.com>
List-ID: <linux-nvdimm@lists.01.org>



On 18/04/17 12:44 AM, Daniel Vetter wrote:
> On Thu, Apr 13, 2017 at 04:05:18PM -0600, Logan Gunthorpe wrote:
>> This is a single straightforward conversion from kmap to sg_map.
>>
>> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> 
> Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> 
> Probably makes sense to merge through some other tree, but please be aware
> of the considerable churn rate in i915 (i.e. make sure your tree is in
> linux-next before you send a pull request for this). Plane B would be to
> get the prep patch in first and then merge the i915 conversion one kernel
> release later.

Yes, as per what I said in my cover letter, I was leaning towards a
"Plan B" style approach.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
