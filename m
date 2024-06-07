Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B910195804
	for <nvdimm@lists.linux.dev>; Fri,  7 Jun 2024 16:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717779034; cv=none; b=pzLQ0+OcbKdxRufW1QHVIzXRXGNfM/FcOXUZLrE4Cg8vftXl4WOq/nNYGq90BrR0G+jQ6kP1DmWRKQa4ZN6i4j0evzawgntsPgmiV+oxyx2Npn6M0Zhs0pQaSciy8fDma16PX9cjOHDTX8NVTnsQ8Xai0GL61HGlNwT0RxJgqLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717779034; c=relaxed/simple;
	bh=ZRShh94EBIDncgMfKsMEaYZBkckkqMmO406vevpRS78=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=LRXV7lt2kTpdj3QtaNBK2xGEQOSqMFFc8sFOzlS4zmr2M8ZCHzYVpBQySB5siVDw7Wl+aPxaBTt2PpPfLMwpItP2PS1SOt69zTNHFh4eozHQcA81PKzrUsFbzwzEnVcXIl0+3asqoxtdLbTLfvHE6rM9j2miiCTba/7UbywdBUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y+FjR3mU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y+FjR3mU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717779032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U7msnklgYBOIfbgcaCxKz002QCLA3EeUmLoFR0q1Nlk=;
	b=Y+FjR3mUyjaV43WQZYl4tlUTqaGujriDLabxGtKXjqYH1DK31cDm1ISZZnq5CGjl0UoC20
	JCSN8dGSujP6jy7lKGljiAU8jdVg7i+NLcP+fMjsIyxLqh4C164vJ+vtIO22h0JLOGD7p8
	32y+3+BnsrfQe1pR/ZJRb5hO9aeFBZ8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-352-mONfFz0OMcW4N61P6CokGA-1; Fri,
 07 Jun 2024 12:50:26 -0400
X-MC-Unique: mONfFz0OMcW4N61P6CokGA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 788FB3806708;
	Fri,  7 Jun 2024 16:50:25 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 32EE43C23;
	Fri,  7 Jun 2024 16:50:24 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 0C00330C1C2E; Fri,  7 Jun 2024 16:50:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 08B043D91D;
	Fri,  7 Jun 2024 18:50:24 +0200 (CEST)
Date: Fri, 7 Jun 2024 18:50:23 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, 
    "Martin K. Petersen" <martin.petersen@oracle.com>, 
    Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, 
    Dan Williams <dan.j.williams@intel.com>, 
    Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
    Ira Weiny <ira.weiny@intel.com>, Keith Busch <kbusch@kernel.org>, 
    Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>, 
    linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
    linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, 
    linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: Re: move integrity settings to queue_limits v2
In-Reply-To: <ZmMqfj3T9Ft680j6@kernel.org>
Message-ID: <d686fec1-c883-b02a-f755-b63d2661df6f@redhat.com>
References: <20240607055912.3586772-1-hch@lst.de> <ZmMqfj3T9Ft680j6@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1



On Fri, 7 Jun 2024, Mike Snitzer wrote:

> On Fri, Jun 07, 2024 at 07:58:54AM +0200, Christoph Hellwig wrote:
> > Hi Jens, hi Martin,
> > 
> > this series converts the blk-integrity settings to sit in the queue
> > limits and be updated through the atomic queue limits API.
> > 
> > I've mostly tested this with nvme, scsi is only covered by simple
> > scsi_debug based tests.
> > 
> > For MD I found an pre-existing error handling bug when combining PI
> > capable devices with not PI capable devices.  The fix was posted here
> > (and is included in the git branch below):
> > 
> >    https://lore.kernel.org/linux-raid/20240604172607.3185916-1-hch@lst.de/
> > 
> > For dm-integrity my testing showed that even the baseline fails to create
> > the luks-based dm-crypto with dm-integrity backing for the authentication
> > data.  As the failure is non-fatal I've not addressed it here.
> 
> Setup is complicated. Did you test in terms of cryptsetup's testsuite?
> Or something else?
> 
> Would really like to see these changes verified to work, with no
> cryptsetup regressions, before they go in.
>  
> > Note that the support for native metadata in dm-crypt by Mikulas will
> > need a rebase on top of this, but as it already requires another
> > block layer patch and the changes in this series will simplify it a bit
> > I hope that is ok.
> 
> Should be fine, Mikulas can you verify this series to pass
> cryptsetup's testsuite before you rebase?

Yes - it passes the cryptsetup testsuite.

Mikulas

> Thanks,
> Mike
> 

