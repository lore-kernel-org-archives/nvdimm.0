Return-Path: <linux-nvdimm-bounces@lists.01.org>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
 <1492121135-4437-17-git-send-email-logang@deltatee.com>
 <063D6719AE5E284EB5DD2968C1650D6DCFFD3CD7@AcuExch.aculab.com>
 <20170418142723.GA27133@char.us.oracle.com>
 <7930aa93-6106-e12f-ba76-e2771d4ec2dc@deltatee.com>
 <20170418155020.GF12001@char.us.oracle.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <bed54c06-eb00-e682-8a50-236ebb9c1db4@deltatee.com>
Date: Tue, 18 Apr 2017 09:59:09 -0600
MIME-Version: 1.0
In-Reply-To: <20170418155020.GF12001@char.us.oracle.com>
Subject: Re: [PATCH 16/22] xen-blkfront: Make use of the new sg_map helper
 function
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
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Steve Wise <swise@opengridcomputing.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, Sumit Semwal <sumit.semwal@linaro.org>, "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>, xen-devel@lists.xensource.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Matthew Wilcox <mawilcox@microsoft.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>, "sparmaintainer@unisys.com" <sparmaintainer@unisys.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "megaraidlinux.pdl@broadcom.com" <megaraidlinux.pdl@broadcom.com>, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, David Laight <David.Laight@ACULAB.COM>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Tejun Heo <tj@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>



On 18/04/17 09:50 AM, Konrad Rzeszutek Wilk wrote:
> I am not sure if you know, but you can add on each patch the respective
> maintainer via 'CC'. That way you can have certain maintainers CCed only
> on the subsystems they cover. You put it after (or before) your SoB and
> git send-email happilly picks it up.

Yes, but I've seen some maintainers complain when they receive a patch
with no context (ie. cover letter and first patch). So I chose to do it
this way. I expect in this situation, no matter what you do, someone is
going to complain about the approach chosen.

Thanks anyway for the tip.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
