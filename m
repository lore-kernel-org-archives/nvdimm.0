Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 033E91A1DFE
 for <linux-nvdimm@lists.01.org>; Thu, 16 Jun 2016 00:34:53 -0700 (PDT)
Date: Thu, 16 Jun 2016 09:34:18 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] libnvdimm: use devm_add_action_or_reset()
Message-ID: <20160616073418.h27grfty4f4jrii5@c203.arch.suse.de>
References: <146603351577.6734.7126797782354241391.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146603351577.6734.7126797782354241391.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 15, 2016 at 04:31:55PM -0700, Dan Williams wrote:
> Clean up needless calls to the action routine by letting
> devm_add_action_or_reset() call it automatically.  This does cause the
> disk to registered and immediately unregistered when a memory allocation
> fails, but the block layer should be prepared for such an event.
> =

> Reported-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good,
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
