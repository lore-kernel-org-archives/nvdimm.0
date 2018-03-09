Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 232472256861D
 for <linux-nvdimm@lists.01.org>; Fri,  9 Mar 2018 14:52:32 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [ndctl PATCH v2] ndctl, list: fix sector_size listing
References: <152063266441.35685.17297254306158306542.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Fri, 09 Mar 2018 17:58:48 -0500
In-Reply-To: <152063266441.35685.17297254306158306542.stgit@dwillia2-desk3.amr.corp.intel.com>
 (Dan Williams's message of "Fri, 09 Mar 2018 13:58:04 -0800")
Message-ID: <x49sh98lutz.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> Commit a7320456f1bc "ndctl: add sector_size to 'ndctl list' output"
> mishandles the case where a namespace does not specify a sector_size,
> but otherwise supports a sector_size selection:
>
>     # ndctl list --namespace=namespace1.0
>     {
>       "dev":"namespace1.0",
>       "mode":"memory",
>       "size":32763805696,
>       "uuid":"7c985ba5-6d33-48bd-8fde-6c25a520abe0",
>       "sector_size":-1,
>       "blockdev":"pmem1",
>       "numa_node":0
>     }
>
> Fixes: a7320456f1bc ("ndctl: add sector_size to 'ndctl list' output")
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good to me

Acked-by: Jeff Moyer <jmoyer@redhat.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
