Received: from bumble.birch.relay.mailchannels.net (bumble.birch.relay.mailchannels.net [23.83.209.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4828C7C
	for <nvdimm@lists.linux.dev>; Wed, 21 Sep 2022 20:55:09 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 78C265C0C86;
	Wed, 21 Sep 2022 20:45:24 +0000 (UTC)
Received: from pdx1-sub0-mail-a276 (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id EFD7B5C0163;
	Wed, 21 Sep 2022 20:45:23 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1663793124; a=rsa-sha256;
	cv=none;
	b=HB+oPHditFG0XrJkWL2bPv5AwKP4h3ERfl5NZ9dk6bRZ3T4ibwVJVQUZteg0qP7rrjj7bf
	EzfBT2aZVfhYh/6APGeE8OPZfPzHuDLFZhO4xxPHpyIVzhXPbAIjGFlWXmuCa8ghjoR3pA
	IeH+tYr2O9VSEN7KrpQTdABoED8OnNMx+rdubFUeIKjw7X8dRrTb89t/5lLe2YIBi6m5lY
	pie74CLmVVGQyGfF668zI+t2ueq4PqYhIz0p82r/dSbzXDFP8TIj1UCrqxOgpZB044QuC1
	aCMgEClRNUjRI1BSU7L45es+U4tHZcAXQxYLOfjiLhJlDw89bbAc/M1yDsLfDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1663793124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/FdaXnbIMBmsJogagwicw8li5jF6bkN1jlqpyYN+wVg=;
	b=iukYKpM8XBygRCuM5OhKlv9el155tGiLoT8SAsS5XJFzo+zHYZ3v4hLs+IK4DZXJTadpoz
	BJQm+y8yAnmT1UMYunqLbxX2wf/+cG98hc9yunoAJ4/GF5+PGRkRU0FkoSsu51eOED0PNv
	dZfakztIXx8j+kRKMhmKfjFt9YwKFAtbocmDsMElWcHRuY5tyPLwaKWGbde9fbNUu9ClXS
	Um6QeFNloiB5aeEuZRnhSgA343K3iR4AIIM4LBejCk3JEACl+KicE/ZAxvRPsounm4/Hbn
	R861X8OD9U5eVtZNAbAXLLL152ld23kQqAexlg0vBj5/QhxCPqohpFsmktTSzA==
ARC-Authentication-Results: i=1;
	rspamd-f776c45b8-n6pdg;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Callous-Lyrical: 075dee41103a545f_1663793124302_203412993
X-MC-Loop-Signature: 1663793124302:1890106420
X-MC-Ingress-Time: 1663793124301
Received: from pdx1-sub0-mail-a276 (pop.dreamhost.com [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.120.183.79 (trex/6.7.1);
	Wed, 21 Sep 2022 20:45:24 +0000
Received: from offworld (ip-213-127-200-122.ip.prioritytelecom.net [213.127.200.122])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a276 (Postfix) with ESMTPSA id 4MXr5Y0S3Kz4C;
	Wed, 21 Sep 2022 13:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1663793123;
	bh=/FdaXnbIMBmsJogagwicw8li5jF6bkN1jlqpyYN+wVg=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=Dp/G215mu6e9Y6n/MtavVgsnJVKLfsboeURBcafGyq67R2jOn3Nk8xFarmcLf5ZRO
	 E9mJttljpONwtHuwdHgLzUjGyztrnWWr1YuJmvrSZOqmELFHh2uEeUP4ItZ9bDnh/U
	 tQ3XvH5v/y4V93HQHwtYYlFi2WGA67uso02Dzxel7iIdrccpjFJOgQrM0CdMJLVIBU
	 tEHvEP6U7cRwBtsC16KFRumV7BDd7B8PI0i6A80vnO/6WFEqL8gHhREseJhfYGjXv2
	 C4kvlxmug2nkDkKhD400RMDZbDZjkvjjjzNqbQl4VXNCuk2FsFvVfLQImf5Z6/EtLf
	 1l7XF0d/zJrOQ==
Date: Wed, 21 Sep 2022 13:25:37 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
	vishal.l.verma@intel.com, alison.schofield@intel.com,
	Jonathan.Cameron@huawei.com
Subject: Re: [PATCH v2 08/19] cxl/pmem: Add "Freeze Security State" security
 command support
Message-ID: <20220921202537.5rske27dgg7bg3db@offworld>
References: <166377414787.430546.3863229455285366312.stgit@djiang5-desk3.ch.intel.com>
 <166377433634.430546.8484308346097721389.stgit@djiang5-desk3.ch.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <166377433634.430546.8484308346097721389.stgit@djiang5-desk3.ch.intel.com>
User-Agent: NeoMutt/20220429

On Wed, 21 Sep 2022, Dave Jiang wrote:

>Create callback function to support the nvdimm_security_ops() ->freeze()
>callback. Translate the operation to send "Freeze Security State" security
>command for CXL memory device.
>
>See CXL 2.0 spec section 8.2.9.5.6.5 for reference.
>
>Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
