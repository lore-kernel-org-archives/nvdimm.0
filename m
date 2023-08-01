Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965252358D
	for <nvdimm@lists.linux.dev>; Tue,  1 Aug 2023 17:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690911834;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yfDi8Qyd9e1CrZbU4NxXthLm/AO5OM3fqQT2PTfehN0=;
	b=HLeHOcYNR7W2MrwzQ3/GT8XhJ2nzI+hbwPJSybyCQLFDYaTsqegxcn1X6QZzWQOvzM+Mv6
	otu91SsybC0Vogd4nOGW72A2g03fnpqfYrM8fRZimFgp8QBJf4J07TerRWupRZlX6KIJrA
	RPrw7Y0jE3q7qXJ8z3lApgRu/BsEN3Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-534-GG6RjHGmOni2xlg-_CIjWA-1; Tue, 01 Aug 2023 13:43:49 -0400
X-MC-Unique: GG6RjHGmOni2xlg-_CIjWA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A54AE800FF1;
	Tue,  1 Aug 2023 17:43:48 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 72F0C40C2063;
	Tue,  1 Aug 2023 17:43:48 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chaitanya Kulkarni <kch@nvidia.com>,  dan.j.williams@intel.com,  vishal.l.verma@intel.com,  dave.jiang@intel.com,  ira.weiny@intel.com,  nvdimm@lists.linux.dev
Subject: Re: [PATCH V2 1/1] pmem: set QUEUE_FLAG_NOWAIT
References: <20230731224617.8665-1-kch@nvidia.com>
	<20230731224617.8665-2-kch@nvidia.com>
	<x491qgmwzuv.fsf@segfault.boston.devel.redhat.com>
	<20230801155943.GA13111@lst.de>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Tue, 01 Aug 2023 13:49:37 -0400
In-Reply-To: <20230801155943.GA13111@lst.de> (Christoph Hellwig's message of
	"Tue, 1 Aug 2023 17:59:43 +0200")
Message-ID: <x49wmyevej2.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Hi, Christoph,

Christoph Hellwig <hch@lst.de> writes:

> On Tue, Aug 01, 2023 at 11:23:36AM -0400, Jeff Moyer wrote:
>> I am slightly embarrassed to have to ask this question, but what are the
>> implications of setting this queue flag?  Is the submit_bio routine
>> expected to never block?
>
> Yes, at least not significantly.

If there happens to be poisoned memory, the write path can make an acpi
device specific method call.  That involves taking a mutex (see the call
chain starting at acpi_ex_enter_interpreter()).  I'm not sure how long a
DSM takes, but I doubt it's fast.

>> Is the I/O expected to be performed
>> asynchronously?
>
> Not nessecarily if it is fast enough..

Clear as mud.  :) It's a memcpy on potentially "slow" memory.  So, the
amount of time spent copying depends on the speed of the cpu, the media
and the size of the I/O.  I don't know off-hand what the upper bound
would be on today's pmem.

-Jeff

