Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA37DFBE7
	for <nvdimm@lists.linux.dev>; Wed,  2 Aug 2023 15:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690989689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+dy+vPxDN0Oc4Dfwi/3Tr1TnfRoXZvJhujCYlsH+q6k=;
	b=JpHubGW1NHi06Anbp3CdjqEc4Z9zFssQP7f2vS3/JVMH6QOddvbzSi4cJg+3KyWwH4cpuJ
	9GNYqRFiJGqUZzycHFb5lW89XIljKHZKEm5bf6i7xgPqZKhQtcmQgCg+Wn2LtkSrqbDPFy
	GRIK95UeXq8S5XsyqBh7RurY/L47rL8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-478-QBqSkhL4OX-oKjDBuC6YAQ-1; Wed, 02 Aug 2023 11:21:24 -0400
X-MC-Unique: QBqSkhL4OX-oKjDBuC6YAQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CFF52858290;
	Wed,  2 Aug 2023 15:21:23 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 941EC112132D;
	Wed,  2 Aug 2023 15:21:23 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chaitanya Kulkarni <chaitanyak@nvidia.com>,  "dan.j.williams\@intel.com" <dan.j.williams@intel.com>,  "vishal.l.verma\@intel.com" <vishal.l.verma@intel.com>,  "dave.jiang\@intel.com" <dave.jiang@intel.com>,  "ira.weiny\@intel.com" <ira.weiny@intel.com>,  "nvdimm\@lists.linux.dev" <nvdimm@lists.linux.dev>,  axboe@kernel.dk,  linux-block@vger.kernel.org
Subject: Re: [PATCH V2 1/1] pmem: set QUEUE_FLAG_NOWAIT
References: <20230731224617.8665-1-kch@nvidia.com>
	<20230731224617.8665-2-kch@nvidia.com>
	<x491qgmwzuv.fsf@segfault.boston.devel.redhat.com>
	<20230801155943.GA13111@lst.de>
	<x49wmyevej2.fsf@segfault.boston.devel.redhat.com>
	<0a2d86d6-34a1-0c8d-389c-1dc2f886f108@nvidia.com>
	<20230802123010.GB30792@lst.de>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Wed, 02 Aug 2023 11:27:12 -0400
In-Reply-To: <20230802123010.GB30792@lst.de> (Christoph Hellwig's message of
	"Wed, 2 Aug 2023 14:30:10 +0200")
Message-ID: <x49o7jpv50v.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3

Christoph Hellwig <hch@lst.de> writes:

> Given that pmem simply loops over an arbitrarily large bio I think
> we also need a threshold for which to allow nowait I/O.  While it
> won't block for giant I/Os, doing all of them in the submitter
> context isn't exactly the idea behind the nowait I/O.
>
> I'm not really sure what a good theshold would be, though.

There's no mention of the latency of the submission side in the
documentation for RWF_NOWAIT.  The man page says "Do not wait for data
which is not immediately available."  Data in pmem *is* immediately
available.  If we wanted to enforce a latency threshold for submission,
it would have to be configurable and, ideally, a part of the API.  I
don't think it's something we should even try to guarantee, though,
unless application writers are asking for it.

So, I think with the change to return -EAGAIN for writes to poisoned
memory, this patch is probably ok.

Chaitanya, could you send a v2?

Thanks,
Jeff

