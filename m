Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21757D51A;
	Sat, 23 Dec 2023 08:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1rGxTq-00062q-4m; Sat, 23 Dec 2023 09:35:34 +0100
Message-ID: <3035e75a-9be0-4bc3-8d4a-6e52c207f277@leemhuis.info>
Date: Sat, 23 Dec 2023 09:35:45 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug in commit aa511ff8218b ("badblocks: switch to the improved
 badblock handling
Content-Language: en-US, de-DE
To: Ira Weiny <ira.weiny@intel.com>, Coly Li <colyli@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>,
 Xiao Ni <xni@redhat.com>, Geliang Tang <geliang.tang@suse.com>,
 Hannes Reinecke <hare@suse.de>, NeilBrown <neilb@suse.de>,
 Vishal L Verma <vishal.l.verma@intel.com>, linux-block@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <6585d5fda5183_9f731294b9@iweiny-mobl.notmuch>
From: "Linux regression tracking #adding (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <6585d5fda5183_9f731294b9@iweiny-mobl.notmuch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1703320539;46daaa1a;
X-HE-SMSGID: 1rGxTq-00062q-4m

[TLDR: I'm adding this report to the list of tracked Linux kernel
regressions; the text you find below is based on a few templates
paragraphs you might have encountered already in similar form.
See link in footer if these mails annoy you.]

On 22.12.23 19:31, Ira Weiny wrote:
> Coly,
> 
> Yesterday I noticed that a few of our nvdimm tests were failing.  I bisected
> the problem to the following commit.
> 
> aa511ff8218b ("badblocks: switch to the improved badblock handling code") 
> 
> Reverting this patch fixed our tests.
> 
> I've also dug into the code a bit and I believe the algorithm for
> badblocks_check() is broken (not yet sure about the other calls).  At the
> very least I see the bb->p pointer being indexed with '-1'.  :-(
> 
> I did notice that this work was due to a bug report in badblock_set().
> Therefore, I'm not sure of that severity of that fix is vs a revert.  But
> at this point I'm not seeing an easy fix so I'm in favor of a revert.

Thanks for the report. To be sure the issue doesn't fall through the
cracks unnoticed, I'm adding it to regzbot, the Linux kernel regression
tracking bot:

#regzbot ^introduced aa511ff8218b
#regzbot title badblocks: nvdimm tests were failing after switch to
impoved code
#regzbot ignore-activity

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply and tell me -- ideally
while also telling regzbot about it, as explained by the page listed in
the footer of this mail.

Developers: When fixing the issue, remember to add 'Link:' tags pointing
to the report (the parent of this mail). See page linked in footer for
details.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.
