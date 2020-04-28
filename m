Return-Path: <SRS0=UXV5=6M=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4311C83004
	for <linux-nvdimm@archiver.kernel.org>; Tue, 28 Apr 2020 18:46:30 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B169A206A1
	for <linux-nvdimm@archiver.kernel.org>; Tue, 28 Apr 2020 18:46:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B169A206A1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwn.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 868DD110BC95F;
	Tue, 28 Apr 2020 11:45:31 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2600:3c01:e000:3a1::42; helo=ms.lwn.net; envelope-from=corbet@lwn.net; receiver=<UNKNOWN> 
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 905B810FC363A
	for <linux-nvdimm@lists.01.org>; Tue, 28 Apr 2020 11:45:29 -0700 (PDT)
Received: from lwn.net (localhost [127.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 8E1452D6;
	Tue, 28 Apr 2020 18:46:27 +0000 (UTC)
Date: Tue, 28 Apr 2020 12:46:26 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Michal Suchanek <msuchanek@suse.de>
Subject: Re: [PATCH] doc: nvdimm: remove reference to non-existent
 CONFIG_NFIT_TEST
Message-ID: <20200428124626.1e80e23a@lwn.net>
In-Reply-To: <20200415211654.10827-1-msuchanek@suse.de>
References: <20200415211654.10827-1-msuchanek@suse.de>
Organization: LWN.net
MIME-Version: 1.0
Message-ID-Hash: AJCYSS55IDVWOOGKUCG45IWFQQ4GQTF2
X-Message-ID-Hash: AJCYSS55IDVWOOGKUCG45IWFQQ4GQTF2
X-MailFrom: corbet@lwn.net
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-nvdimm@lists.01.org, Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/AJCYSS55IDVWOOGKUCG45IWFQQ4GQTF2/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 15 Apr 2020 23:16:50 +0200
Michal Suchanek <msuchanek@suse.de> wrote:

> The test driver is in tools/testing/nvdimm and cannot be selected by a
> config option.
> 
> Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> ---
>  Documentation/driver-api/nvdimm/nvdimm.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/driver-api/nvdimm/nvdimm.rst b/Documentation/driver-api/nvdimm/nvdimm.rst
> index 08f855cbb4e6..79c0fd39f2af 100644
> --- a/Documentation/driver-api/nvdimm/nvdimm.rst
> +++ b/Documentation/driver-api/nvdimm/nvdimm.rst
> @@ -278,8 +278,8 @@ by a region device with a dynamically assigned id (REGION0 - REGION5).
>         be contiguous in DPA-space.
>  
>      This bus is provided by the kernel under the device
> -    /sys/devices/platform/nfit_test.0 when CONFIG_NFIT_TEST is enabled and
> -    the nfit_test.ko module is loaded.  This not only test LIBNVDIMM but the
> +    /sys/devices/platform/nfit_test.0 when the nfit_test.ko module from
> +    tools/testing/nvdimm is loaded.  This not only test LIBNVDIMM but the
>      acpi_nfit.ko driver as well.

Applied, thanks.

jon
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
