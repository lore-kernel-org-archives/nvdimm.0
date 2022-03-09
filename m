Received: from buffalo.birch.relay.mailchannels.net (buffalo.birch.relay.mailchannels.net [23.83.209.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DBA15BD
	for <nvdimm@lists.linux.dev>; Wed,  9 Mar 2022 07:19:41 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id C3EFD2C184E;
	Wed,  9 Mar 2022 07:02:33 +0000 (UTC)
Received: from pdx1-sub0-mail-a224.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 577502C0A54;
	Wed,  9 Mar 2022 07:02:01 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1646809351; a=rsa-sha256;
	cv=none;
	b=ikCnnjuifLHzpsWghol22mWyOeagEASNTKGHUKcIJo3JbX8l2E4EayCqUQv3LRy4PM1nUv
	BTX19Vt/WL6WW0QOBB20tXJqkvPNfVxOcshfWbZgLX1yqCYi/+whTZsZPqmIb4HRWMPk7s
	stjudNQiya5TKvixycnX4YLZ6ujl2zzeotDi1qlBU8UDpZRuNuz/RNms464giY33Uo0Nh9
	DW9/W2H6O+ABsT6fG0qEYkjsrqg5LFMSM1/ZM9xAMCpoViY8LeUoKde4ONdvB7SrYztyEb
	+XnU0deeNRgTG9PKgj2Jid7Ov5xnRNP9J6/K+V9ytZLFTYfRIZJ2KDeMoDQKsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1646809351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iu2wpkNj094AxInrlajS6C6oTiAOF8EDxBw33pv/gZk=;
	b=LVvgPQisTc7gWq9R40Xhx4M+Ld7gZ+x8cy7iXmBV4RsioOdAdCi7NmLxZr1uNukfMU97cB
	JiKlxGTVSCecAUcS0ycNvb4vXzNWbWG2pqQtPaY2eYkNwQRmIO3eSZKjL9JS2b2gmdnfXM
	EmAf2kAmw5ZoEkFk3q2s2JIbJaszsQBdbEXijEtx3lr3k0zIBUdQ0k2/gyN36CjSPm88ja
	M7XnYpzcg5O7HcR6bqwib7kCoEEKAUrJtcRmm9fMo8AYYBCt2h3gOLUx++SkTW93y+kip5
	PngkEa5Mg9vdYH9kxY9Rvds0+CmUFFCDMUkI/bmkYaWD5PVEZ5n2XLMW+CXCww==
ARC-Authentication-Results: i=1;
	rspamd-56df6fd94d-jd4wk;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from pdx1-sub0-mail-a224.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.107.255.183 (trex/6.5.3);
	Wed, 09 Mar 2022 07:02:33 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Blushing-Turn: 7a809d573b3b7644_1646809353529_1421627043
X-MC-Loop-Signature: 1646809353529:1811626044
X-MC-Ingress-Time: 1646809353529
Received: from [172.20.1.215] (unknown [192.210.17.121])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a224.dreamhost.com (Postfix) with ESMTPSA id 4KD36057V1z1Pr;
	Tue,  8 Mar 2022 23:02:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1646809321;
	bh=Iu2wpkNj094AxInrlajS6C6oTiAOF8EDxBw33pv/gZk=;
	h=Subject:From:To:Cc:Date:Content-Type:Content-Transfer-Encoding;
	b=PVx6H8TBPv16zmRwX8UTdDWFf+2is89+hZUPIJSXF25n8AvHnih8fCST/86au5Cme
	 HMATnWHldY2ft6BxrY5FE1SBPV08nVe2Bh9H0/JfFSeoA7N6XdT/461iuzAcQnb+5U
	 OkXzVob5dae304uemj+x2A8eYIFKa/97tJ1+SB8VRQPp4/jUf/VXawGsO+nGfM1adm
	 VKuoS6RDEWKwh27QUSXUe7hVkkxRFme9s9CK6ZJr5MHZNICHhY2admLL0Ap5L+11WC
	 uoaiB1mdOJXajBuHwa0VVyZnWcTg5x38okjgYsg/+bitK1wCk8UpAtODgYl3UHYAFH
	 7panIkhapN2vw==
Message-ID: <6d9e99e902a0aeb80c1889f50a44b59853005655.camel@stgolabs.net>
Subject: Re: [LSF/MM/BPF BOF idea] CXL BOF discussion
From: Davidlohr Bueso <dave@stgolabs.net>
To: Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org
Cc: 'Ben Widawsky' <ben.widawsky@intel.com>, 'Vishal Verma'
 <vishal.l.verma@intel.com>, 'Dan Williams' <dan.j.williams@intel.com>, 
 "Schofield, Alison" <alison.schofield@intel.com>, linux-mm@kvack.org,
 nvdimm@lists.linux.dev
Date: Tue, 08 Mar 2022 22:53:18 -0800
In-Reply-To: <YiZ0Jmhyf515EJzD@iweiny-desk3>
References: <YiZ0Jmhyf515EJzD@iweiny-desk3>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 2022-03-07 at 13:07 -0800, Ira Weiny wrote:
> Hello,
> 
> I was curious if anyone attending LSF/mm would be interested in a CXL BOF?
> 
> I'm still hoping to get an invite, but if I do I would be happy to organize
> some time to discuss the work being done.  It would be great to meet people
> face to face if possible too.

I would be very interested in this.

Thanks,
Davidlohr
