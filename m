Received: from weasel.tulip.relay.mailchannels.net (weasel.tulip.relay.mailchannels.net [23.83.218.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675F1199234
	for <nvdimm@lists.linux.dev>; Mon, 30 Sep 2024 19:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.247
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727725132; cv=pass; b=nfHmvEcGDkXV5yFLAyoP7oMwAka0nATbcJY7eRMHwX7piZVvty2vXlLz1Uphsns7ZBoTLVRY+1O/olYbX7jNqCdh6AY4tkjnPvS+UqZXnz+9SjHiiNZw7pmzNJzaEn1hnG57tGzEPE2u7hRMMcopPl/ukewfqCKb9lFFdrB4Oas=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727725132; c=relaxed/simple;
	bh=drvfoqRwLTPzEhF/GU5GtuJlQm1UODZr1pFD/5K1JrU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lxlq9Ac7d8ersxNFi5oX0gnxzlTwhqxAN7uR6ys92ubOhGwGQ9IDbqArqr4274TtucaWsLqNFsUPyR6N4A5c/g38zmUdw0xzH+rm6r7v4XCP9HlkP+njr2m0AZY+vk15bdCDNkWjTJ1Yzt+VoObv/61yFbVvBRlOaLc1A48eO/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net; spf=pass smtp.mailfrom=stgolabs.net; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=Ka4ws+iS; arc=pass smtp.client-ip=23.83.218.247
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="Ka4ws+iS"
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 755E95C626B;
	Mon, 30 Sep 2024 19:31:03 +0000 (UTC)
Received: from pdx1-sub0-mail-a313.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 1128A5C6634;
	Mon, 30 Sep 2024 19:31:03 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1727724663; a=rsa-sha256;
	cv=none;
	b=Ey+7Dmd50zH8+noevr5o877sRUjywh3eDgJ0x+tqIWAzzGKoj9902R1siYjDo5xBJvnnvo
	OAbTbRNo2wTWEC+W5xuqmz6R9tBAgNhYfDZh8Qs0ofzRabMfczPNNI27eZ6lMIrg0AlrK6
	TaDOttwbDN2oglQGxz1tmC68a3gSyuWfMo3lPATZdoGXZb+MsmFwWT+2N6XD1e01/kIL7A
	sFr0KygRoystzJDzWjwD6l991FESBdDach0Ht7UuXK99KTWF/lcnCAeaIqHsQft95Yx6wq
	ox6vfA5RpWOTfLTDpjk78ntjaqos2Kp5DQjFAtXjMOHnErUhUnR5HP9eNq+SnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1727724663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aRWDBQPsV6KbvpbJ88AAbGqasNK6ffj6dOPqME6msik=;
	b=DVkuASwblSHzC8Wb3d89NoPn12vfNMLDFliGevfXLWR6VFoDfKCOYWHqVuYDfNeeGgEEYG
	5oQoD+eDB2VU+d2pme4hbgX4SgSD0KcRsbLxh6viHli6dtmTrlJtMrDonEYn1naeR3jRRq
	BBD3W9wcOj1/K/tUcrhicrjwF53N42AxfvStzUc8U+19yxayWXxJ7WfLZjr58peSR1e8dv
	lrNp9Hq0+JLO/Qt9PL9iRfJElnK6Azp12kkerQkx/k5Ri4HaKtDWOaDrWKEhSbaGLgLgCn
	k20JWKpcOhrUwE/C6IJpA1u0WSyJ67IDZgRLzHxef1J5kRRGEFr6qIKvNWfb7A==
ARC-Authentication-Results: i=1;
	rspamd-5b468d8b77-4ctkl;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Drop-Thoughtful: 1a96d8b7640a480b_1727724663307_2316578376
X-MC-Loop-Signature: 1727724663307:2520058090
X-MC-Ingress-Time: 1727724663307
Received: from pdx1-sub0-mail-a313.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.114.165.125 (trex/7.0.2);
	Mon, 30 Sep 2024 19:31:03 +0000
Received: from offworld (unknown [104.36.31.106])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a313.dreamhost.com (Postfix) with ESMTPSA id 4XHWQG2jfszKk;
	Mon, 30 Sep 2024 12:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1727724662;
	bh=aRWDBQPsV6KbvpbJ88AAbGqasNK6ffj6dOPqME6msik=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=Ka4ws+iS4gXGBIQ9t8Sa9VaX9Pz5vmqpgsB2Lx2FgIP1Ymh+TtIVlOwjbTh4mORRA
	 twM2du+w5aJFbPeUGSo0wYNCEzAMGlJkRg87QW3aYF1d4bHTQKX5si3FQWiLKForAH
	 mg1+Qg57D56o6z8ov3+TLsIhTYo12dHt3eei4FPtUtCSCCsCw6fwDE8zMdfQ7vg3aj
	 HdiymQD+u+jC1dxOTQFBmRnC+CMiMqq9MWq1hu04cGIa3J29hzdk0McEqqkCe6/omK
	 km7OU4rJhofkSV4U2Q0GBaGLck/PZPjKevMAa9EHoWSqu5+J/jDMxbgmWY5SJkA1tY
	 qJtAzQKu0lkaA==
Date: Mon, 30 Sep 2024 12:29:35 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Alison Schofield <alison.schofield@intel.com>
Cc: vishal.l.verma@intel.com, y-goto@fujitsu.com, dave.jiang@intel.com, 
	dan.j.williams@intel.com, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Subject: Re: [PATCH -ndctl] cxl/memdev: Introduce sanitize-memdev
 functionality
Message-ID: <f6ybfabcft5wcpx2wuoxf3qgwset3h4nhngn5c4jk6ssudl5gj@o2ssocnihy6t>
References: <20240928211643.140264-1-dave@stgolabs.net>
 <ZvrhusA7So_u51W_@aschofie-mobl2.lan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZvrhusA7So_u51W_@aschofie-mobl2.lan>
User-Agent: NeoMutt/20240425

Hi Alison,

On Mon, 30 Sep 2024, Alison Schofield wrote:\n
>+ nvdimm@lists.linux.dev
>
>On Sat, Sep 28, 2024 at 02:16:42PM -0700, Davidlohr Bueso wrote:
>> Add a new cxl_memdev_sanitize() to libcxl to support triggering memory
>> device sanitation, in either Sanitize and/or Secure Erase, per the
>> CXL 3.0 spec.
>>
>> This is analogous to 'ndctl sanitize-dimm'.
>>
>> Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
>
>Hi David,
>
>I'm wrangling patches for ndctl now and need your help with this one.

Ah I missed that, sorry I didn't Cc you.

>
>Looking at the lore history, you posted a patchset for wait-sanitize &
>sanitize-memdev in Apr'03.[1] and update with rev2.[2] Later in Oct'23
>Dan posted a patchset with wait-sanitize and a unit test that was merged
>in ndctl v80.[3,4]  A quick look at the code tells me Dan did not just
>grab your implementation. It differs.

While the implementations of wait-sanitize are slightly different between
what I posted and Dan's patches, it is not fundamentally very different
(poll on the file).

>
>Can you confirm that the two features as a set are what you want today?

I can.

>Are the last comments from Vishal and I addressed? [2]

So I had made sure to address the libcxl.sym comments but just noticed
that the -s option wanted to be removed as it will the the default. So
only have the -e option for secure erase alternative (and not allow for
both to be specified at the same time).

      cxl sanitize-memdev -e mem0 <-- secure erase
      cxl sanitize-memdev mem0 <-- sanitize

>Can the existing unit test be expanded with a sanitize-memdev test case?

Good point. Yeah we could trivially replace those

      echo 1 > /sys/bus/cxl/devices/${inactive}/security/sanitize && err $LINENO

with

      "$CXL" sanitize-memdev $inactive || err $LINENO


Thanks,
Davidlohr
