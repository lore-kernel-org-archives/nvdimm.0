Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E35A321102DAE
 for <linux-nvdimm@lists.01.org>; Fri,  8 Jun 2018 07:59:08 -0700 (PDT)
Subject: Re: [qemu PATCH 1/5] gitignore: ignore generated qapi job files
References: <20180607223111.27792-1-ross.zwisler@linux.intel.com>
From: Eric Blake <eblake@redhat.com>
Message-ID: <edcae62f-e3b6-6e25-60a5-843eeae89396@redhat.com>
Date: Fri, 8 Jun 2018 09:59:00 -0500
MIME-Version: 1.0
In-Reply-To: <20180607223111.27792-1-ross.zwisler@linux.intel.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Ross Zwisler <ross.zwisler@linux.intel.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On 06/07/2018 05:31 PM, Ross Zwisler wrote:
> With a fully built QEMU I currently see the following with "git status":
> 
>    Untracked files:
>      (use "git add <file>..." to include in what will be committed)
> 
>    	qapi/qapi-commands-job.c
>    	qapi/qapi-commands-job.h
>    	qapi/qapi-events-job.c
>    	qapi/qapi-events-job.h
>    	qapi/qapi-types-job.c
>    	qapi/qapi-types-job.h
>    	qapi/qapi-visit-job.c
>    	qapi/qapi-visit-job.h
> 
> These are all generated files.  Ignore them.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Kevin Wolf <kwolf@redhat.com>
> Cc: Eric Blake <eblake@redhat.com>
> Fixes: commit bf42508f24ee ("job: Introduce qapi/job.json")

You're the third to post this:

https://lists.gnu.org/archive/html/qemu-devel/2018-05/msg07280.html
https://lists.gnu.org/archive/html/qemu-devel/2018-06/msg01624.html

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3266
Virtualization:  qemu.org | libvirt.org
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
