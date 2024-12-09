Received: from sender4-pp-o95.zoho.com (sender4-pp-o95.zoho.com [136.143.188.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B13320B
	for <nvdimm@lists.linux.dev>; Mon,  9 Dec 2024 04:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733716938; cv=pass; b=TVEty5gnTlPolkBBaoPPBoLqm0tbQpEkWCP5dUYMMgsUTqE5n9LITcCoYEXXSuNwsRfAGleYWwGrBrY32OfcrWRfoW+CEZK3xmLCm1F1o1mcpvDIigfHtF51GYWGSCvkZf4bfj0qm1o/8CCEj2nXH2QmbfkTdDlkIMmH8hsAWek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733716938; c=relaxed/simple;
	bh=i0AVdv2HVY0cBJywfMoIC/bEPBBI4Kc8iWkiyFFwwTM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qNZAaH+PYw9VPvw91KMi/jbDcjQ1QQ7zo2rBf3dBtL0j9RbimmZ7nQX9olc2td6c9UheGL2tQ+H6oCwloBZiEgDT+tl6F4M/BYU4kRRg1EE5wZqfB6hN4ueCVQbN47LJn3R5ZycJw3lK065ebR6vbyiYf+sD5m38tEwGvM5bX7M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com; spf=pass smtp.mailfrom=zohomail.com; dkim=pass (1024-bit key) header.d=zohomail.com header.i=ming.li@zohomail.com header.b=Cyn2rzbu; arc=pass smtp.client-ip=136.143.188.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zohomail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zohomail.com header.i=ming.li@zohomail.com header.b="Cyn2rzbu"
ARC-Seal: i=1; a=rsa-sha256; t=1733716931; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=PCNvWq9nJMWvWfKBDgodZijmo8auebrYnmkZrZye3TzXWm7LvSoUyBefG8y2CnSa6uQA285OMoF1byVNpdYPvhCqW+o+7ZfeaOWrfSaXmwHSwoIooDgbw30+cvUSNnUkVAOSIFTp1FZPGjcz4XUVOLYNV4kIqfKuFqA9qSEMfNU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1733716931; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=RA9KVV9H/T3fwr9oDUhv9+qG5LPXwAHewKwoee34Wqk=; 
	b=l9zQo/W2q/K61nVXlOVW2EsAEgQ4ldwiUs4bQe0Cn6CFgfIn0MW86jskZyH2Rq/W3imYGoqufzr12plveX3a5W1ID/pMjtpBGWIp2Q2WwUznat5YLHanGJnueVlmNW2pHfe5X6JjYGofOWcwC3KrnvG/6WX/VYgTlqWk+JkBBjk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=zohomail.com;
	spf=pass  smtp.mailfrom=ming.li@zohomail.com;
	dmarc=pass header.from=<ming.li@zohomail.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1733716931;
	s=zm2022; d=zohomail.com; i=ming.li@zohomail.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Feedback-ID:Message-Id:Reply-To;
	bh=RA9KVV9H/T3fwr9oDUhv9+qG5LPXwAHewKwoee34Wqk=;
	b=Cyn2rzbuLk1QlyZU3A4vXTdLNVJs2sx06FUM+w5C5mdjpNY8b5hGZe5+cIlpoaoW
	1qK8jKgmc+2jmsl0qYB91VaIF/ry9n8pb10byQE+5JB1blsQBJx1DcW8iJqj3SWNWl1
	no8IwNwe8+If+GxjxJ61JspiZnnrf6YoLeJPcNRw=
Received: by mx.zohomail.com with SMTPS id 1733716928915758.8277959061644;
	Sun, 8 Dec 2024 20:02:08 -0800 (PST)
Message-ID: <ecccced3-07a1-4b4a-9319-c6d88518e368@zohomail.com>
Date: Mon, 9 Dec 2024 12:02:06 +0800
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
From: Li Ming <ming.li@zohomail.com>
In-Reply-To: <6712b7bf2c1cd_10a03294b3@dwillia2-mobl3.amr.corp.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Feedback-ID: rr0801122760383f751de4e337f86a03e80000221daa2c86967e238b2ea4b6139ee1ce48b6857490326dd1a8:zu08011227c9892118f48149ab2326439c0000201441fab27c53b15f071cf642553ad1f953722b26334612a4:rf0801122608557309d5c5baf0c255d2e300008d94b61ab4fb4dfe00e0ce43e692411dcfaee7fa80f0d6b4:ZohoMail
X-ZohoMailClient: External



On 10/19/2024 3:32 AM, Dan Williams wrote:
> Alison Schofield wrote:
>>
>> + linux-cxl mailing list
> 
> Thanks for forwarding...
> 
>> On Fri, Oct 11, 2024 at 05:58:52PM +0800, Coly Li wrote:
>>> Hi list,
>>>
>>> Recently I have a report for a warning message from CXL subsystem,
>>> [ 48.142342] cxl_port port2: Couldn't locate the CXL.cache and CXL.mem capability array header.
>>> [ 48.144690] cxl_port port3: Couldn't locate the CXL.cache and CXL.mem capability array header.
>>> [ 48.144704] cxl_port port3: HDM decoder capability not found
>>> [ 48.144850] cxl_port port4: Couldn't locate the CXL.cache and CXL.mem capability array header.
>>> [ 48.144859] cxl_port port4: HDM decoder capability not found
>>> [ 48.170374] cxl_port port6: Couldn't locate the CXL.cache and CXL.mem capability array header.
>>> [ 48.172893] cxl_port port7: Couldn't locate the CXL.cache and CXL.mem capability array header.
>>> [ 48.174689] cxl_port port7: HDM decoder capability not found
>>> [ 48.175091] cxl_port port8: Couldn't locate the CXL.cache and CXL.mem capability array header.
>>> [ 48.175105] cxl_port port8: HDM decoder capability not found
>>>
>>> After checking the source code I realize this is not a real bug,
>>> just a warning message that expected device was not detected.  But
>>> from the above warning information itself, users/customers are
>>> worried there is something wrong (IMHO indeed not).
>>>
>>> Is there any chance that we can improve the code logic that only
>>> printing out the warning message when it is really a problem to be
>>> noticed? 
> 
> There is a short term fix and a long term fix. The short term fix could
> be to just delete the warning message, or downgrade it to dev_dbg(), for
> now since it is more often a false positive than not. The long term fix,
> and the logic needed to resolve false-positive reports, is to flip the
> capability discovery until *after* it is clear that there is a
> downstream endpoint capable of CXL.cachemem.
> 
> Without an endpoint there is no point in reporting that a potentially
> CXL capable port is missing cachemem registers.
> 
> So, if you want to send a patch changing that warning to dev_dbg() for
> now I would support that.
> 

I noticed the short term solution been merged, may I know if anyone is working on the long term solution? If not, I can work on it.

Thanks
Ming
