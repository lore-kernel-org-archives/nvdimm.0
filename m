Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A857EA8
	for <nvdimm@lists.linux.dev>; Tue, 23 May 2023 04:38:22 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2054E225C8;
	Tue, 23 May 2023 04:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1684816701; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WAYA0NV+vOzsI9Gb5w4I9DHICOPBYPQ7rwX4WOVMFxY=;
	b=orWFOsUaYIfAXAtwdmh1dofxwrDzPE+/r9LqNcJZ9RQEO1VAr4nUPQsFcu/fF5Lu2aiMD8
	cWz6g/cQNZ9hyvd8UUA0o1svAHWbmwGi3zBHUjKKEHJmNiWwJodHmyMIAUCpiYzEISlhFX
	aIwXn/VmKZhFCyoFnlj4uU6PQs7NGto=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1684816701;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WAYA0NV+vOzsI9Gb5w4I9DHICOPBYPQ7rwX4WOVMFxY=;
	b=zdcwWRMBR8flLtp0EEW+xOHIRxsOwhWPys5qxxUiVRPeFFyqAc+nwnSlFm/2EvmvicxWxy
	Ck2JXb4sMqlhv3CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4F0C013588;
	Tue, 23 May 2023 04:38:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id OKDABzpDbGSMZAAAMHmgww
	(envelope-from <colyli@suse.de>); Tue, 23 May 2023 04:38:18 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH v6 0/7] badblocks improvement for multiple bad block
 ranges
From: Coly Li <colyli@suse.de>
In-Reply-To: <daca108d-4dd3-ecbf-c630-69d4bc2b96c0@huaweicloud.com>
Date: Tue, 23 May 2023 12:38:05 +0800
Cc: linux-block@vger.kernel.org,
 nvdimm@lists.linux.dev,
 linux-raid@vger.kernel.org,
 Dan Williams <dan.j.williams@intel.com>,
 Geliang Tang <geliang.tang@suse.com>,
 Hannes Reinecke <hare@suse.de>,
 Jens Axboe <axboe@kernel.dk>,
 NeilBrown <neilb@suse.de>,
 Richard Fan <richard.fan@suse.com>,
 Vishal L Verma <vishal.l.verma@intel.com>,
 Wols Lists <antlists@youngman.org.uk>,
 Xiao Ni <xni@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A43DF8F4-2DEF-4865-B4B4-4B5FBF834678@suse.de>
References: <20220721121152.4180-1-colyli@suse.de>
 <daca108d-4dd3-ecbf-c630-69d4bc2b96c0@huaweicloud.com>
To: Li Nan <linan666@huaweicloud.com>
X-Mailer: Apple Mail (2.3731.500.231)



> 2023=E5=B9=B45=E6=9C=8823=E6=97=A5 10:38=EF=BC=8CLi Nan =
<linan666@huaweicloud.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi Coly Li,
>=20
> Recently, I have been trying to fix the bug of backblocks settings, =
and I found that your patch series has already fixed the bug. This patch =
series has not been applied to mainline at present, may I ask if you =
still plan to continue working on it?

Sure, I will post an update version for your testing.

Coly Li

