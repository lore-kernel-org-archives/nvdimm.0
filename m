Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C267F80349
 for <linux-nvdimm@lists.01.org>; Tue,  7 Mar 2017 00:53:41 -0800 (PST)
Subject: Re: [PATCH 3/3] Remove unnecessary newline
References: <cover.1488844291.git.linda.knippers@hpe.com>
 <59e71d8abf46dc0e9e928924a317e80aa15f6f0c.1488844291.git.linda.knippers@hpe.com>
From: Johannes Thumshirn <jthumshirn@suse.de>
Message-ID: <1506efeb-56fc-114c-bed7-0dd62817641c@suse.de>
Date: Tue, 7 Mar 2017 09:53:40 +0100
MIME-Version: 1.0
In-Reply-To: <59e71d8abf46dc0e9e928924a317e80aa15f6f0c.1488844291.git.linda.knippers@hpe.com>
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
> The newline in MODULE_PARM_DESC causes modinfo to print the parameter
> data type on a separate line, which is different from all the other
> module parameters and could potentially cause a problem for someone
> parsing the output of modinfo.
> =

> Signed-off-by: Linda Knippers <linda.knippers@hpe.com>
> ---

Thanks,
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
