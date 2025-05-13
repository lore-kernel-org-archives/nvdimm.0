Received: from rusty.tulip.relay.mailchannels.net (rusty.tulip.relay.mailchannels.net [23.83.218.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4758353365
	for <nvdimm@lists.linux.dev>; Tue, 13 May 2025 20:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.252
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747167597; cv=pass; b=em0fvS9ZhdiNIfksdQNGmOVCJSVx3VW24uyCzU3t6u0OfG7JDZShtj84nHJoDm08pFWsHvFCjkUGRWlbuIt7xMNQamvvtBxFfxgfPDRC0Twr6qZGhYPlPEPBWehjJqCiPz1rbERrG9yqVt6gCtqD1GIMyxmT5LzkVqI7s5xOZEQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747167597; c=relaxed/simple;
	bh=GLfC7kTtxiuhbdgFQ9EUf9TFPVRR/F295bBgXHKYq6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G5iAveZ5ypS/Uh9THmC1OgnDAuNDDHE6dYsii+7Cy1263Alv1gb1mt1QAgOxU8gVslKSqdM1hVNhQ+tApNxeTbCZ75k0J8itx2ETqS0KQi8ENAOas6uZk3DMe4bFAqobh+ard/siZc/EsMG1gbxc39RM4sVdxyQvdHGtOWjYv3Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net; spf=pass smtp.mailfrom=stgolabs.net; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=Mfp3V0Ze; arc=pass smtp.client-ip=23.83.218.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="Mfp3V0Ze"
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 57E9F8A5186;
	Tue, 13 May 2025 19:42:54 +0000 (UTC)
Received: from pdx1-sub0-mail-a213.dreamhost.com (100-119-90-230.trex-nlb.outbound.svc.cluster.local [100.119.90.230])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id CEDE18A52F7;
	Tue, 13 May 2025 19:42:53 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1747165373; a=rsa-sha256;
	cv=none;
	b=O0aWYq+VhZMRbfZdh8XY89x4X17NtCTotI65R3wgx7dlQcblnuYy865oUMckgGrYNgEPT9
	8hVrUxcNQ/lYtkANIJiORiJfy1YP950GL8r9GfvzGlvBmh2I3c9NSGFuPYXSXtZUST7mHI
	Z0PR+ju48z1VoyJBlrLjWu5Huap7VSNEvuJEWqSE5bOL+YCk8W6VQfBj70HZ2bFoOwyHXy
	lukNQSeNggXWg6zA08oR8LjUZlvM0hnG8SPQ4sXpphwsoPGi4MngfOtmA2wqKvWgfh+B1y
	8mIyHrOfW7IgM1nofTq2Jy6/CKZqSesABDMzuC4+CqI6CxvjGQGTlKbXYhwSMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1747165373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GLfC7kTtxiuhbdgFQ9EUf9TFPVRR/F295bBgXHKYq6E=;
	b=v9nzkJnl+22Rm8umBp297nHNMjfoQMl5PJxdgX2T+DUZ2VHI3Fr2jUywDwtsDbRZ1XnwVD
	SQC/SXNFqZV9uiMZ6/vLhXwmUUWBHWd71OR8TXXW9idA4qeDJsXvy7183Z7jGRXDxTYHkL
	dkGPm7fsMD7w2KINHI2pqc3bk2VxtAn3xA/BFmxIDVr37eZRuvDWcbDxWT9PyyfSjZidR5
	xvmQ6nYQyBtLoxwcKkbgSLUSbadQjTydDQVNp54VO0e2h6Bp2f167EdhdwKBrGljRqtHW1
	AF2jvvp+672mrW43J/kDlv1j2LvMh/xOAzG6I+5WPNHcZzrAN5HhiCh4SVUYqQ==
ARC-Authentication-Results: i=1;
	rspamd-57f676fcfb-kbpb8;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Snatch-Juvenile: 44cb933277233e57_1747165374096_1974108462
X-MC-Loop-Signature: 1747165374096:3273404662
X-MC-Ingress-Time: 1747165374096
Received: from pdx1-sub0-mail-a213.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.119.90.230 (trex/7.0.3);
	Tue, 13 May 2025 19:42:54 +0000
Received: from offworld (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a213.dreamhost.com (Postfix) with ESMTPSA id 4Zxn253HSmz6m;
	Tue, 13 May 2025 12:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1747165373;
	bh=GLfC7kTtxiuhbdgFQ9EUf9TFPVRR/F295bBgXHKYq6E=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=Mfp3V0Ze2AtgIX9EriLWoZHfwxxyLsFBmpcEP6aUaQ+xgSE2HLUDdTa9A6POTaxoh
	 wauehyiqO/Lq1Nzmty9wP+8cvao3jSwUzqZXdaor9dOXziBYMJmesZ5dUyJGPKCcXN
	 q2Zg9Q2VFh5DAo05MxhnMVR0/LvRwRoy2eU5fN9gy5eMnUG5lzzhbjujjXy+W/jtZI
	 QvleDSTgZkx3lrd4lvhVVYQYrOWUDYtnDKdwZHHY6PpWpTp5ExORcYiViWoJC4YnaY
	 2P78Pj+7SU0hOD4LVI83jIHBx6jUGiDxhx3mfWYaOJxn4/TUPj704XPYFZAMkdJQ8X
	 vkGRaNhY+RfUQ==
Date: Tue, 13 May 2025 12:42:50 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Alison Schofield <alison.schofield@intel.com>
Cc: y-goto@fujitsu.com, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [PATCH v4 -ndctl] cxl/memdev: Introduce sanitize-memdev
 functionality
Message-ID: <20250513194250.2mpidwy452awflf6@offworld>
References: <20250318234543.562359-1-dave@stgolabs.net>
 <aAkuxAG30M_WxT8d@aschofie-mobl2.lan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aAkuxAG30M_WxT8d@aschofie-mobl2.lan>
User-Agent: NeoMutt/20220429

On Wed, 23 Apr 2025, Alison Schofield wrote:

>On Tue, Mar 18, 2025 at 04:45:43PM -0700, Davidlohr Bueso wrote:
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
>Is there anyone you can ping directly to review this one?
>
>It's been lingering a bit and I'd want to see a review by someone other
>than me before merging.

Yasunori-san, since you were requesting this (as opposed to just doing a
trivial echo 1 > ...), could you please give this a test/review?

Thanks,
Davidlohr
