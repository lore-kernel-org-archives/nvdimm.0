Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 546602110718F
 for <linux-nvdimm@lists.01.org>; Fri,  8 Jun 2018 08:36:31 -0700 (PDT)
Date: Fri, 8 Jun 2018 09:36:30 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [qemu PATCH 1/5] gitignore: ignore generated qapi job files
Message-ID: <20180608153630.GB27156@linux.intel.com>
References: <20180607223111.27792-1-ross.zwisler@linux.intel.com>
 <edcae62f-e3b6-6e25-60a5-843eeae89396@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <edcae62f-e3b6-6e25-60a5-843eeae89396@redhat.com>
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
To: Eric Blake <eblake@redhat.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Michael S. Tsirkin" <mst@redhat.com>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 08, 2018 at 09:59:00AM -0500, Eric Blake wrote:
> On 06/07/2018 05:31 PM, Ross Zwisler wrote:
> > With a fully built QEMU I currently see the following with "git status":
> > 
> >    Untracked files:
> >      (use "git add <file>..." to include in what will be committed)
> > 
> >    	qapi/qapi-commands-job.c
> >    	qapi/qapi-commands-job.h
> >    	qapi/qapi-events-job.c
> >    	qapi/qapi-events-job.h
> >    	qapi/qapi-types-job.c
> >    	qapi/qapi-types-job.h
> >    	qapi/qapi-visit-job.c
> >    	qapi/qapi-visit-job.h
> > 
> > These are all generated files.  Ignore them.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Cc: Kevin Wolf <kwolf@redhat.com>
> > Cc: Eric Blake <eblake@redhat.com>
> > Fixes: commit bf42508f24ee ("job: Introduce qapi/job.json")
> 
> You're the third to post this:
> 
> https://lists.gnu.org/archive/html/qemu-devel/2018-05/msg07280.html
> https://lists.gnu.org/archive/html/qemu-devel/2018-06/msg01624.html

I pulled your master branch yesterday before posting the series.  If multiple
people are sending fixes to the same issue and the fixes are correct, the
easiest way to stop getting those fixes is probably to merge one of the
patches.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
