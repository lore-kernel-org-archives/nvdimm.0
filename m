Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1F7361A1E00
 for <linux-nvdimm@lists.01.org>; Mon,  4 Jul 2016 00:32:03 -0700 (PDT)
Date: Mon, 4 Jul 2016 09:31:22 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] nfit: use devm_add_action_or_reset()
Message-ID: <20160704073122.nkvnnminfrnuhhb4@c203.arch.suse.de>
References: <1467606771-21704-1-git-send-email-vikas.cha.sajjan@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1467606771-21704-1-git-send-email-vikas.cha.sajjan@hpe.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Vikas C Sajjan <vikas.cha.sajjan@hpe.com>
Cc: linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 04, 2016 at 10:02:51AM +0530, Vikas C Sajjan wrote:
> If devm_add_action() fails, we are explicitly calling the cleanup to free
> the resources allocated. Lets use the helper devm_add_action_or_reset()
> and return directly in case of error, since the cleanup function
> has been already called by the helper if there was any error.
> =

> Signed-off-by: Vikas C Sajjan <vikas.cha.sajjan@hpe.com>

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- =

Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
