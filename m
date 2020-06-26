Return-Path: <SRS0=5hxt=AH=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2095BC433E3
	for <linux-nvdimm@archiver.kernel.org>; Fri, 26 Jun 2020 17:34:23 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 02829206DD
	for <linux-nvdimm@archiver.kernel.org>; Fri, 26 Jun 2020 17:34:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 02829206DD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rjwysocki.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id F02111103E37B;
	Fri, 26 Jun 2020 10:34:22 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=79.96.170.134; helo=cloudserver094114.home.pl; envelope-from=rjw@rjwysocki.net; receiver=<UNKNOWN> 
Received: from cloudserver094114.home.pl (cloudserver094114.home.pl [79.96.170.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id B52021102228F
	for <linux-nvdimm@lists.01.org>; Fri, 26 Jun 2020 10:34:18 -0700 (PDT)
Received: from 89-64-83-223.dynamic.chello.pl (89.64.83.223) (HELO kreacher.localnet)
 by serwer1319399.home.pl (79.96.170.134) with SMTP (IdeaSmtpServer 0.83.415)
 id aea2085616e28395; Fri, 26 Jun 2020 19:34:16 +0200
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Dan Williams <dan.j.williams@intel.com>, Erik Kaneda <erik.kaneda@intel.com>
Subject: [RFT][PATCH v3 0/4] ACPI: ACPICA / OSL: Avoid unmapping ACPI memory inside of the AML interpreter
Date: Fri, 26 Jun 2020 19:28:27 +0200
Message-ID: <2788992.3K7huLjdjL@kreacher>
In-Reply-To: <2713141.s8EVnczdoM@kreacher>
References: <158889473309.2292982.18007035454673387731.stgit@dwillia2-desk3.amr.corp.intel.com> <2713141.s8EVnczdoM@kreacher>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID-Hash: TGT7VIIJNQ3ZCHYDGSCQQ6DP4MIGIQRT
X-Message-ID-Hash: TGT7VIIJNQ3ZCHYDGSCQQ6DP4MIGIQRT
X-MailFrom: rjw@rjwysocki.net
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: rafael.j.wysocki@intel.com, Len Brown <lenb@kernel.org>, Borislav Petkov <bp@alien8.de>, James Morse <james.morse@arm.com>, Myron Stowe <myron.stowe@redhat.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org, Bob Moore <robert.moore@intel.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/TGT7VIIJNQ3ZCHYDGSCQQ6DP4MIGIQRT/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Transfer-Encoding: 7bit

Hi All,

On Monday, June 22, 2020 3:50:42 PM CEST Rafael J. Wysocki wrote:
> Hi All,
> 
> This series is to address the problem with RCU synchronization occurring,
> possibly relatively often, inside of acpi_ex_system_memory_space_handler(),
> when the namespace and interpreter mutexes are held.
> 
> Like I said before, I had decided to change the approach used in the previous
> iteration of this series and to allow the unmap operations carried out by 
> acpi_ex_system_memory_space_handler() to be deferred in the first place,
> which is done in patches [1-2/4].

In the meantime I realized that calling syncrhonize_rcu_expedited() under the
"tables" mutex within ACPICA is not quite a good idea too and that there is no
reason for any users of acpi_os_unmap_memory() in the tree to use the "sync"
variant of unmapping.

So, unless I'm missing something, acpi_os_unmap_memory() can be changed to
always defer the final unmapping and the only ACPICA change needed to support
that is the addition of the acpi_os_release_unused_mappings() call to get rid
of the unused mappings when leaving the interpreter (module the extra call in
the debug code for consistency).

So patches [1-2/4] have been changed accordingly.

> However, it turns out that the "fast-path" mapping is still useful on top of
> the above to reduce the number of ioremap-iounmap cycles for the same address
> range and so it is introduced by patches [3-4/4].

Patches [3-4/4] still do what they did, but they have been simplified a bit
after rebasing on top of the new [1-2/4].

The below information is still valid, but it applies to the v3, of course.

> For details, please refer to the patch changelogs.
> 
> The series is available from the git branch at
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
>  acpica-osl
> 
> for easier testing.

Also the series have been tested locally.

Thanks,
Rafael


_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
