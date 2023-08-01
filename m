Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658151F95B
	for <nvdimm@lists.linux.dev>; Tue,  1 Aug 2023 15:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690903070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4rCmeRwjz3OGl981j8kHzGu75lFPVl/EFjahar0NDv0=;
	b=UBGC5wET1hIVm6ev6tNSAS6/0yvMY4R/C8zrpFvK8aogAMvIFlxhif1gloUWCmyj6vgrKS
	/+ChA417r+OtMepPGkL5iRJXdDvWrWiYuFXnz6/O7rU5qsurhMl2EuJNNS/KSPT1P/qNfV
	UTG4b9h3CYZYazKv5plVt51GQpcfvTM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-50-Hs3CquVGN9ir7Deoc0oikQ-1; Tue, 01 Aug 2023 11:17:48 -0400
X-MC-Unique: Hs3CquVGN9ir7Deoc0oikQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D95BE895682;
	Tue,  1 Aug 2023 15:17:47 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A5940492CA6;
	Tue,  1 Aug 2023 15:17:47 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Chaitanya Kulkarni <kch@nvidia.com>
Cc: <dan.j.williams@intel.com>,  <vishal.l.verma@intel.com>,  <dave.jiang@intel.com>,  <ira.weiny@intel.com>,  <hch@lst.de>,  <nvdimm@lists.linux.dev>
Subject: Re: [PATCH V2 1/1] pmem: set QUEUE_FLAG_NOWAIT
References: <20230731224617.8665-1-kch@nvidia.com>
	<20230731224617.8665-2-kch@nvidia.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Tue, 01 Aug 2023 11:23:36 -0400
In-Reply-To: <20230731224617.8665-2-kch@nvidia.com> (Chaitanya Kulkarni's
	message of "Mon, 31 Jul 2023 15:46:17 -0700")
Message-ID: <x491qgmwzuv.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Chaitanya Kulkarni <kch@nvidia.com> writes:

> Set the QUEUE_FLAG_NOWAIT. Following are the performance numbers with
> io_uring fio engine for random read, note that device has been populated
> fully with randwrite workload before taking these numbers :-

I am slightly embarrassed to have to ask this question, but what are the
implications of setting this queue flag?  Is the submit_bio routine
expected to never block?  Is the I/O expected to be performed
asynchronously?  If either of those is the case, then pmem does not
qualify.

-Jeff

>
> linux-block (pmem-nowait-on) # grep IOPS  pmem*fio | column -t
> pmem-nowait-off-1.fio:  read:  IOPS=3683k,  BW=14.0GiB/s
> pmem-nowait-off-2.fio:  read:  IOPS=3819k,  BW=14.6GiB/s
> pmem-nowait-off-3.fio:  read:  IOPS=3999k,  BW=15.3GiB/s
>
> pmem-nowait-on-1.fio:   read:  IOPS=5837k,  BW=22.3GiB/s
> pmem-nowait-on-2.fio:   read:  IOPS=5936k,  BW=22.6GiB/s
> pmem-nowait-on-3.fio:   read:  IOPS=5945k,  BW=22.7GiB/s
>
> linux-block (pmem-nowait-on) # grep cpu  pmem*fio | column -t
> pmem-nowait-off-1.fio:  cpu  :  usr=7.09%,   sys=29.65%,  ctx=198742065
> pmem-nowait-off-2.fio:  cpu  :  usr=6.89%,   sys=30.56%,  ctx=205817652
> pmem-nowait-off-3.fio:  cpu  :  usr=6.86%,   sys=30.94%,  ctx=222627094
>
> pmem-nowait-on-1.fio:   cpu  :  usr=10.58%,  sys=88.44%,  ctx=27181   
> pmem-nowait-on-2.fio:   cpu  :  usr=10.50%,  sys=87.75%,  ctx=25746   
> pmem-nowait-on-3.fio:   cpu  :  usr=10.67%,  sys=88.60%,  ctx=28261   
>
> linux-block (pmem-nowait-on) # grep slat  pmem*fio | column -t
> pmem-nowait-off-1.fio:  slat  (nsec):  min=432,   max=50847k,  avg=9324.69
> pmem-nowait-off-2.fio:  slat  (nsec):  min=441,   max=52557k,  avg=9132.45
> pmem-nowait-off-3.fio:  slat  (nsec):  min=430,   max=36113k,  avg=9132.63
>
> pmem-nowait-on-1.fio:   slat  (nsec):  min=1393,  max=68090k,  avg=7615.31
> pmem-nowait-on-2.fio:   slat  (nsec):  min=1222,  max=44137k,  avg=7493.77
> pmem-nowait-on-3.fio:   slat  (nsec):  min=1493,  max=40100k,  avg=7486.36
>
> Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
> ---
>  drivers/nvdimm/pmem.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 46e094e56159..ddd485c377eb 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -543,6 +543,7 @@ static int pmem_attach_disk(struct device *dev,
>  	blk_queue_max_hw_sectors(q, UINT_MAX);
>  	blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
>  	blk_queue_flag_set(QUEUE_FLAG_SYNCHRONOUS, q);
> +	blk_queue_flag_set(QUEUE_FLAG_NOWAIT, q);
>  	if (pmem->pfn_flags & PFN_MAP)
>  		blk_queue_flag_set(QUEUE_FLAG_DAX, q);

