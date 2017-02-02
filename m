Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 09F0B81FED
 for <linux-nvdimm@lists.01.org>; Thu,  2 Feb 2017 00:01:05 -0800 (PST)
Date: Thu, 2 Feb 2017 09:00:57 +0100
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] libnvdimm, namespace: do not delete namespace-id 0
Message-ID: <20170202080057.GA3629@linux-x5ow.site>
References: <148597412157.20990.8337801110453234119.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <148597412157.20990.8337801110453234119.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Feb 01, 2017 at 10:35:21AM -0800, Dan Williams wrote:
> Given that the naming of pmem devices changes from the pmemX form to the
> pmemX.Y form when namespace id is greater than 0, arrange for namespaces
> with id-0 to be exempt from deletion. Otherwise a simple reconfiguration
> of an existing namespace to a new mode results in a name change of the
> resulting block device:
> =

>     # ndctl list --namespace=3Dnamespace1.0
>     {
>       "dev":"namespace1.0",
>       "mode":"raw",
>       "size":2147483648,
>       "uuid":"3dadf3dc-89b9-4b24-b20e-abc8a4707ce3",
>       "blockdev":"pmem1"
>     }
> =

>     # ndctl create-namespace --reconfig=3Dnamespace1.0 --mode=3Dmemory --=
force
>     {
>       "dev":"namespace1.1",
>       "mode":"memory",
>       "size":2111832064,
>       "uuid":"7b4a6341-7318-4219-a02c-fb57c0bbf613",
>       "blockdev":"pmem1.1"
>     }
> =

> This change does require tooling changes to explicitly look for
> namespaceX.0 if the seed has already advanced to another namespace.
> =

> Cc: <stable@vger.kernel.org>
> Fixes: 98a29c39dc68 ("libnvdimm, namespace: allow creation of multiple pm=
em-namespaces per region")
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

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
