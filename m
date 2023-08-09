Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF811988B
	for <nvdimm@lists.linux.dev>; Wed,  9 Aug 2023 13:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691589040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zyEA9XgeHbdVYN6ZkazjG2slqksdlMRSGBi2Ff7HDJw=;
	b=C9p376mzxmp8bry7mYRrAJwp3wjMM0nTrnqOrw2+qKNGK2JXAsMdABoVct9ZdQxGGWefX8
	lx/YjFZ9TQnQ25DEtaxKCbIkyMt0nVNrrD5/6kVBY6dvCavo3xpP38lTrpPbiZZ155NcnZ
	EBA3IRwhLuRPQIF5tm8Qf8pnXOUEnfw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-213-z-cJDWA5NOey6JsxWnzRnw-1; Wed, 09 Aug 2023 09:50:34 -0400
X-MC-Unique: z-cJDWA5NOey6JsxWnzRnw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FC0E85D062;
	Wed,  9 Aug 2023 13:50:34 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 595BE40C6F4E;
	Wed,  9 Aug 2023 13:50:34 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: nvdimm@lists.linux.dev,  dan.j.williams@intel.com,  vishal.l.verma@intel.com
Subject: Re: [PATCH v2 1/2] nvdimm/pfn_dev: Prevent the creation of zero-sized namespaces
References: <20230809053512.350660-1-aneesh.kumar@linux.ibm.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Wed, 09 Aug 2023 09:56:22 -0400
In-Reply-To: <20230809053512.350660-1-aneesh.kumar@linux.ibm.com> (Aneesh
	Kumar K. V.'s message of "Wed, 9 Aug 2023 11:05:11 +0530")
Message-ID: <x49wmy42ubd.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> writes:

> On architectures that have different page size values used for kernel
> direct mapping and userspace mappings, the user can end up creating zero-sized
> namespaces as shown below
>
> :/sys/bus/nd/devices/region1# cat align
> 0x1000000
> /sys/bus/nd/devices/region1# echo 0x200000 > align
> /sys/bus/nd/devices/region1/dax1.0# cat supported_alignments
> 65536 16777216
>  $ ndctl create-namespace -r region1 -m devdax -s 18M --align 64K
> {
>   "dev":"namespace1.0",
>   "mode":"devdax",
>   "map":"dev",
>   "size":0,
>   "uuid":"3094329a-0c66-4905-847e-357223e56ab0",
>   "daxregion":{
>     "id":1,
>     "size":0,
>     "align":65536
>   },
>   "align":65536
> }
> similarily for fsdax
>
>  $ ndctl create-namespace -r region1 -m fsdax  -s 18M --align 64K
> {
>   "dev":"namespace1.0",
>   "mode":"fsdax",
>   "map":"dev",
>   "size":0,
>   "uuid":"45538a6f-dec7-405d-b1da-2a4075e06232",
>   "sector_size":512,
>   "align":65536,
>   "blockdev":"pmem1"
> }
>
> In commit 9ffc1d19fc4a ("mm/memremap_pages: Introduce memremap_compat_align()")
> memremap_compat_align was added to make sure the kernel always creates
> namespaces with 16MB alignment. But the user can still override the
> region alignment and no input validation is done in the region alignment
> values to retain the flexibility user had before. However, the kernel
> ensures that only part of the namespace that can be mapped via kernel
> direct mapping page size is enabled. This is achieved by tracking the
> unmapped part of the namespace in pfn_sb->end_trunc. The kernel also
> ensures that the start address of the namespace is also aligned to the
> kernel direct mapping page size.
>
> Depending on the user request, the kernel implements userspace mapping
> alignment by updating pfn device alignment attribute and this value is
> used to adjust the start address for userspace mappings. This is tracked
> in pfn_sb->dataoff. Hence the available size for userspace mapping is:
>
> usermapping_size = size of the namespace - pfn_sb->end_trun - pfn_sb->dataoff
>
> If the kernel finds the user mapping size zero then don't allow the
> creation of namespace.
>
> After fix:
> $ ndctl create-namespace -f  -r region1 -m devdax  -s 18M --align 64K
> libndctl: ndctl_dax_enable: dax1.1: failed to enable
>   Error: namespace1.2: failed to enable
>
> failed to create namespace: No such device or address
>
> And existing zero sized namespace will be marked disabled.
> root@ltczz75-lp2:/home/kvaneesh# ndctl  list -N -r region1 -i
> [
>   {
>     "dev":"namespace1.0",
>     "mode":"raw",
>     "size":18874368,
>     "uuid":"94a90fb0-8e78-4fb6-a759-ffc62f9fa181",
>     "sector_size":512,
>     "state":"disabled"
>   },
>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> ---
> Changes from v1:
> * Use resource_size() helper instead of opencoding it
>
>  drivers/nvdimm/pfn_devs.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> index af7d9301520c..0777b1626f6c 100644
> --- a/drivers/nvdimm/pfn_devs.c
> +++ b/drivers/nvdimm/pfn_devs.c
> @@ -452,8 +452,9 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
>  	u64 checksum, offset;
>  	struct resource *res;
>  	enum nd_pfn_mode mode;
> +	resource_size_t res_size;
>  	struct nd_namespace_io *nsio;
> -	unsigned long align, start_pad;
> +	unsigned long align, start_pad, end_trunc;
>  	struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
>  	struct nd_namespace_common *ndns = nd_pfn->ndns;
>  	const uuid_t *parent_uuid = nd_dev_to_uuid(&ndns->dev);
> @@ -503,6 +504,7 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
>  	align = le32_to_cpu(pfn_sb->align);
>  	offset = le64_to_cpu(pfn_sb->dataoff);
>  	start_pad = le32_to_cpu(pfn_sb->start_pad);
> +	end_trunc = le32_to_cpu(pfn_sb->end_trunc);
>  	if (align == 0)
>  		align = 1UL << ilog2(offset);
>  	mode = le32_to_cpu(pfn_sb->mode);
> @@ -584,7 +586,8 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
>  	 */
>  	nsio = to_nd_namespace_io(&ndns->dev);
>  	res = &nsio->res;
> -	if (offset >= resource_size(res)) {
> +	res_size = resource_size(res);
> +	if (offset >= res_size) {
>  		dev_err(&nd_pfn->dev, "pfn array size exceeds capacity of %s\n",
>  				dev_name(&ndns->dev));
>  		return -EOPNOTSUPP;
> @@ -610,6 +613,10 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
>  		return -EOPNOTSUPP;
>  	}
>  
> +	if (offset >= (res_size - start_pad - end_trunc)) {
> +		dev_err(&nd_pfn->dev, "bad offset with small namespace\n");
> +		return -EOPNOTSUPP;
> +	}
>  	return 0;
>  }
>  EXPORT_SYMBOL(nd_pfn_validate);
> @@ -810,7 +817,8 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
>  	else
>  		return -ENXIO;
>  
> -	if (offset >= size) {
> +	if (offset >= (size - end_trunc)) {
> +		/* This results in zero size devices */
>  		dev_err(&nd_pfn->dev, "%s unable to satisfy requested alignment\n",
>  				dev_name(&ndns->dev));
>  		return -ENXIO;

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

