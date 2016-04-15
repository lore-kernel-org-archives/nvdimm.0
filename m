Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 898ED1A236F
 for <linux-nvdimm@lists.01.org>; Fri, 15 Apr 2016 00:11:41 -0700 (PDT)
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] libnvdimm, pmem: clarify the write+clear_poison+write flow
Date: Fri, 15 Apr 2016 09:11:39 +0200
Message-ID: <1569643.CdmplTuF3X@c203>
In-Reply-To: <146068804768.24085.7722589204633361307.stgit@dwillia2-desk3.jf.intel.com>
References: <146068804768.24085.7722589204633361307.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
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
To: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Donnerstag, 14. April 2016 19:40:47 CEST Dan Williams wrote:
> The ACPI specification does not specify the state of data after a clear
> poison operation.  Potential future libnvdimm bus implementations for
> other architectures also might not specify or disagree on the state of
> data after clear poison.  Clarify why we write twice.
> =

> Reported-by: Jeff Moyer <jmoyer@redhat.com>
> Reported-by: Vishal Verma <vishal.l.verma@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- =

Johannes Thumshirn                                                         =
                       Storage
jthumshirn@suse.de                                                         =
    +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
