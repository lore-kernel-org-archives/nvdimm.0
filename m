Return-Path: <SRS0=+zvK=X5=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C361C4360C
	for <linux-nvdimm@archiver.kernel.org>; Fri,  4 Oct 2019 21:39:49 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3944E21D81
	for <linux-nvdimm@archiver.kernel.org>; Fri,  4 Oct 2019 21:39:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3944E21D81
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=mit.edu
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 2B24510097F23;
	Fri,  4 Oct 2019 14:40:51 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=18.9.28.11; helo=outgoing.mit.edu; envelope-from=tytso@mit.edu; receiver=<UNKNOWN> 
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id AAF1F10097F21
	for <linux-nvdimm@lists.01.org>; Fri,  4 Oct 2019 14:40:49 -0700 (PDT)
Received: from callcc.thunk.org (guestnat-104-133-0-98.corp.google.com [104.133.0.98] (may be forged))
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x94LcCr9027392
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 4 Oct 2019 17:38:15 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
	id 9FA7C42088C; Fri,  4 Oct 2019 17:38:12 -0400 (EDT)
Date: Fri, 4 Oct 2019 17:38:12 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [PATCH v18 00/19] kunit: introduce KUnit, the Linux kernel unit
 testing framework
Message-ID: <20191004213812.GA24644@mit.edu>
References: <20190923090249.127984-1-brendanhiggins@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190923090249.127984-1-brendanhiggins@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Message-ID-Hash: EA5N5OZYN3QDMYMVDHQ4MPCRVJQMUGZK
X-Message-ID-Hash: EA5N5OZYN3QDMYMVDHQ4MPCRVJQMUGZK
X-MailFrom: tytso@mit.edu
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: frowand.list@gmail.com, gregkh@linuxfoundation.org, jpoimboe@redhat.com, keescook@google.com, kieran.bingham@ideasonboard.com, mcgrof@kernel.org, peterz@infradead.org, robh@kernel.org, sboyd@kernel.org, shuah@kernel.org, yamada.masahiro@socionext.com, devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, kunit-dev@googlegroups.com, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-nvdimm@lists.01.org, linux-um@lists.infradead.org, Alexander.Levin@microsoft.com, Tim.Bird@sony.com, amir73il@gmail.com, dan.carpenter@oracle.com, daniel@ffwll.ch, jdike@addtoit.com, joel@jms.id.au, julia.lawall@lip6.fr, khilman@baylibre.com, knut.omang@oracle.com, mpe@ellerman.id.au, pmladek@suse.com, rdunlap@infradead.org, richard@nod.at, rientjes@google.com, rostedt@goodmis.org, wfg@linux.intel.com, torvalds@linux-foundation.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/EA5N5OZYN3QDMYMVDHQ4MPCRVJQMUGZK/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Sep 23, 2019 at 02:02:30AM -0700, Brendan Higgins wrote:
> ## TL;DR
> 
> This revision addresses comments from Linus[1] and Randy[2], by moving
> top level `kunit/` directory to `lib/kunit/` and likewise moves top
> level Kconfig entry under lib/Kconfig.debug, so the KUnit submenu now
> shows up under the "Kernel Hacking" menu.

This question is primarily directed at Shuah and Linus....

What's the current status of the kunit series now that Brendan has
moved it out of the top-level kunit directory as Linus has requested?

There doesn't appear to have been many comments or changes since since
September 23rd, and I was very much hoping they could land before
-rc2, since I've been hoping to add unit tests for ext4.

Is kunit likely to be able to be landed in Linus's tree during this
development cycle?

Many thanks!

					- Ted
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
