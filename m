Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BDBF82195406C
 for <linux-nvdimm@lists.01.org>; Thu, 27 Apr 2017 13:19:42 -0700 (PDT)
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
 <1493144468-22493-16-git-send-email-logang@deltatee.com>
 <20170426073720.okv33ly2ldepilti@dhcp-3-128.uk.xensource.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <df6586e2-7d45-6b0b-facb-4dea882df06e@deltatee.com>
Date: Thu, 27 Apr 2017 14:19:24 -0600
MIME-Version: 1.0
In-Reply-To: <20170426073720.okv33ly2ldepilti@dhcp-3-128.uk.xensource.com>
Subject: Re: [PATCH v2 15/21] xen-blkfront: Make use of the new sg_map helper
 function
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>, dri-devel@lists.freedesktop.org, dm-devel@redhat.com, target-devel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, devel@driverdev.osuosl.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, Sumit Semwal <sumit.semwal@linaro.org>, open-iscsi@googlegroups.com, linux-media@vger.kernel.org, Juergen Gross <jgross@suse.com>, Julien Grall <julien.grall@arm.com>, intel-gfx@lists.freedesktop.org, sparmaintainer@unisys.com, linux-raid@vger.kernel.org, megaraidlinux.pdl@broadcom.com, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, netdev@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <linux-nvdimm@lists.01.org>



On 26/04/17 01:37 AM, Roger Pau Monn=E9 wrote:
> On Tue, Apr 25, 2017 at 12:21:02PM -0600, Logan Gunthorpe wrote:
>> Straightforward conversion to the new helper, except due to the lack
>> of error path, we have to use SG_MAP_MUST_NOT_FAIL which may BUG_ON in
>> certain cases in the future.
>>
>> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
>> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>> Cc: Juergen Gross <jgross@suse.com>
>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Cc: "Roger Pau Monn=E9" <roger.pau@citrix.com>
>> ---
>>  drivers/block/xen-blkfront.c | 20 +++++++++++---------
>>  1 file changed, 11 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
>> index 3945963..ed62175 100644
>> --- a/drivers/block/xen-blkfront.c
>> +++ b/drivers/block/xen-blkfront.c
>> @@ -816,8 +816,9 @@ static int blkif_queue_rw_req(struct request *req, s=
truct blkfront_ring_info *ri
>>  		BUG_ON(sg->offset + sg->length > PAGE_SIZE);
>>  =

>>  		if (setup.need_copy) {
>> -			setup.bvec_off =3D sg->offset;
>> -			setup.bvec_data =3D kmap_atomic(sg_page(sg));
>> +			setup.bvec_off =3D 0;
>> +			setup.bvec_data =3D sg_map(sg, 0, SG_KMAP_ATOMIC |
>> +						 SG_MAP_MUST_NOT_FAIL);
> =

> I assume that sg_map already adds sg->offset to the address?

Correct.

> Also wondering whether we can get rid of bvec_off and just increment bvec=
_data,
> adding Julien who IIRC added this code.

bvec_off is used to keep track of the offset within the current mapping
so it's not a great idea given that you'd want to kunmap_atomic the
original address and not something with an offset. It would be nice if
this could be converted to use the sg_miter interface but that's a much
more invasive change that would require someone who knows this code and
can properly test it. I'd be very grateful if someone actually took that on.

Logan

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
