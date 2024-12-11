Received: from sender4-pp-o95.zoho.com (sender4-pp-o95.zoho.com [136.143.188.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AAB139CFF
	for <nvdimm@lists.linux.dev>; Wed, 11 Dec 2024 14:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733928543; cv=pass; b=RLZiqZN8TRxOcghtFIOZTRp7X45CpEEfjlWupG++H4ZY84pS752cAIs+AShp0Y9i0awkIXny63sObkrR0hyPAAwGg1AF6iNmqZVV/p89svyeVJe8+aC0L8SwEW984nvoaILotUmfPfUQX3u5DTsdj0N42gb6wbq+RVTrNlcs3Qk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733928543; c=relaxed/simple;
	bh=iDRQelwrIxTeP0VF7qjm+HyC1wL9uVshOINz+FpzdCg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tj/khdBTErdP6uHMZQu+L/meVwgnJmuumPFiDSr5WPzHireIZJx7MWTLi+KcdoWHCLkDnhixTF6BmGHanOwwOILjoPSiQpXpniltr+1iMS0LtII9BPO61sDiqFlcC5LL7SYQa3v1mUBtvEKDXkhLAQx1aQiKlYUZOv10MUg8n+8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com; spf=pass smtp.mailfrom=zohomail.com; dkim=pass (1024-bit key) header.d=zohomail.com header.i=ming.li@zohomail.com header.b=Tf5vb6cY; arc=pass smtp.client-ip=136.143.188.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zohomail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zohomail.com header.i=ming.li@zohomail.com header.b="Tf5vb6cY"
ARC-Seal: i=1; a=rsa-sha256; t=1733928536; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=bBKPYboQqSC/jgFe5aB1i0tV1vfn1rIqVJd4ipaQnojRYmN3/UxiNdgwL3Nfqa9fr1L/RnE1nuJAedmzbubDgiErpFVw0HO6QEI0QDV4BlPIgmUyz5ZefpJDaytVcxO0KH/j3NrEC86Sx/MkQEozyKCN1hB9V9cr+1H4dTvU+pQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1733928536; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=iDRQelwrIxTeP0VF7qjm+HyC1wL9uVshOINz+FpzdCg=; 
	b=mlt/kmQbXwBagd14/gkacRo8+qoNqQ44+Hac+OqRM7/E5sJS2zt8XlAfUSh7CHZh6496od4YimJ/nwY/4mZe6miMHx8jyd9bNQxQmRcND6n21Xv/2PmtO2hPvW4f6gSCxbmnvBCOTssndDQrpPq2SMICOtzVXAthx5QRSthFsNo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=zohomail.com;
	spf=pass  smtp.mailfrom=ming.li@zohomail.com;
	dmarc=pass header.from=<ming.li@zohomail.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1733928536;
	s=zm2022; d=zohomail.com; i=ming.li@zohomail.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Feedback-ID:Message-Id:Reply-To;
	bh=iDRQelwrIxTeP0VF7qjm+HyC1wL9uVshOINz+FpzdCg=;
	b=Tf5vb6cYhdL6p6mEAwY1ndppC0RTFP5G/3tOTTQocJvCKJ3N+s3jzDX2R1Jsh9Ok
	fnWWW4HQamOq10m1NBOJOUx43ack7l6VRFOnbtpMYYlZSXgLCX/e3gyeHSyq84cX5Fz
	Zs/xlWVWMYHOdbIecDosWdQFJsauJ78XnC8pylLY=
Received: by mx.zohomail.com with SMTPS id 1733928533708758.3301442161908;
	Wed, 11 Dec 2024 06:48:53 -0800 (PST)
Message-ID: <fd1e87e0-1cce-4589-a684-d5e272650211@zohomail.com>
Date: Wed, 11 Dec 2024 22:48:51 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Removing a misleading warning message?
To: Dan Williams <dan.j.williams@intel.com>,
 Alison Schofield <alison.schofield@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 Coly Li <colyli@suse.de>
References: <15237B14-B55B-4737-9A98-D76AEDB4AEAD@suse.de>
 <ZxElg0RC_S1TY2cd@aschofie-mobl2.lan>
 <6712b7bf2c1cd_10a03294b3@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <ecccced3-07a1-4b4a-9319-c6d88518e368@zohomail.com>
 <6758a50391a54_10a0832944b@dwillia2-xfh.jf.intel.com.notmuch>
From: Li Ming <ming.li@zohomail.com>
In-Reply-To: <6758a50391a54_10a0832944b@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Feedback-ID: rr08011227252673b73e8be9db69ebb3280000cab68486afe53556ef1d8d323055d8ee55a0b201806f4963a7:zu080112279794973e493be9d31e4bfbfd0000b2c02ed88e7319946bb635fb127d89a1482f74dd6329e8a324:rf08011226e6627a01f59c07fa0db31df5000028aa433a54c773f186523cdde5a46fecd43d619824ced76f:ZohoMail
X-ZohoMailClient: External

On 12/11/2024 4:30 AM, Dan Williams wrote:
> Li Ming wrote:
> [..]
>>> There is a short term fix and a long term fix. The short term fix could
>>> be to just delete the warning message, or downgrade it to dev_dbg(), for
>>> now since it is more often a false positive than not. The long term fix,
>>> and the logic needed to resolve false-positive reports, is to flip the
>>> capability discovery until *after* it is clear that there is a
>>> downstream endpoint capable of CXL.cachemem.
>>>
>>> Without an endpoint there is no point in reporting that a potentially
>>> CXL capable port is missing cachemem registers.
>>>
>>> So, if you want to send a patch changing that warning to dev_dbg() for
>>> now I would support that.
>>>
>> I noticed the short term solution been merged, may I know if anyone is
>> working on the long term solution? If not, I can work on it.
> Hi Ming,
>
> To my knowledge nobody is working on it, so feel free to take a look.
> Just note though that if this gets in someone else's critical path they
> could also produce some patches. I.e. typical Linux kernel task
> wrangling where the first to post a workable solution usually gets to
> drive the discussion.
>
Hi Dan,


Understand, thanks for your information, I am also willing to review those patches if that happens.


Ming

