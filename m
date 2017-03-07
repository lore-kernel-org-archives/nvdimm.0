Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DD43080349
 for <linux-nvdimm@lists.01.org>; Tue,  7 Mar 2017 00:53:06 -0800 (PST)
Subject: Re: [PATCH 1/3] Allow override of built-in bitmasks for NVDIMM DSMs
References: <cover.1488844291.git.linda.knippers@hpe.com>
 <8d9f517851514711df1012ed03d218931ea12b55.1488844291.git.linda.knippers@hpe.com>
From: Johannes Thumshirn <jthumshirn@suse.de>
Message-ID: <0a2d2462-94df-74ec-44e1-53eee228c771@suse.de>
Date: Tue, 7 Mar 2017 09:53:04 +0100
MIME-Version: 1.0
In-Reply-To: <8d9f517851514711df1012ed03d218931ea12b55.1488844291.git.linda.knippers@hpe.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Linda Knippers <linda.knippers@hpe.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 03/07/2017 01:25 AM, Linda Knippers wrote:
> As it is today, we can't enable or test new NVDIMM management functions
> provided by new firmware and tools without changing the kernel.  We also
> can't prevent documented DSM functions from being called in the
> case of buggy firmware.  This patch provides a module parameter that
> overrides the DSM function mask that is built into the kernel.
> =

> If the "disable_vendor_specific" module parameter is also used
> we ignore the new parameter. =

> =

> Signed-off-by: Linda Knippers <linda.knippers@hpe.com>
> ---

Looks good to me,
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
