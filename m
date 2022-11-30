Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A255645;
	Wed, 30 Nov 2022 10:30:45 +0000 (UTC)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1p0KMV-00077a-7B; Wed, 30 Nov 2022 11:30:43 +0100
Message-ID: <da90b96d-ef1e-4827-b983-15d103a3a1ef@leemhuis.info>
Date: Wed, 30 Nov 2022 11:30:42 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH 0/2] fsdax,xfs: fix warning messages #forregzbot
Content-Language: en-US, de-DE
To: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org
Cc: "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: <1669301694-16-1-git-send-email-ruansy.fnst@fujitsu.com>
From: Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <1669301694-16-1-git-send-email-ruansy.fnst@fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1669804245;cde9a49c;
X-HE-SMSGID: 1p0KMV-00077a-7B

[Note: this mail is primarily send for documentation purposes and/or for
regzbot, my Linux kernel regression tracking bot. That's why I removed
most or all folks from the list of recipients, but left any that looked
like a mailing lists. These mails usually contain '#forregzbot' in the
subject, to make them easy to spot and filter out.]

On 24.11.22 15:54, Shiyang Ruan wrote:
> Many testcases failed in dax+reflink mode with warning message in dmesg.
> This also effects dax+noreflink mode if we run the test after a
> dax+reflink test.  So, the most urgent thing is solving the warning
> messages.

Darrick in https://lore.kernel.org/all/Y4bZGvP8Ozp+4De%2F@magnolia/
wrote "dax and reflink are totally broken on 6.1". Hence, add this to
the tracking to be sure it's not forgotten.

#regzbot ^introduced 35fcd75af3ed
#regzbot title xfs/dax/reflink are totally broken on 6.1
#regzbot ignore-activity

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.
