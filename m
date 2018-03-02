Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 878FD21E082B8
 for <linux-nvdimm@lists.01.org>; Fri,  2 Mar 2018 15:43:36 -0800 (PST)
Received: by mail-oi0-x244.google.com with SMTP id c12so8256967oic.7
 for <linux-nvdimm@lists.01.org>; Fri, 02 Mar 2018 15:49:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180302225734.GE31240@lst.de>
References: <151996281307.28483.12343847096989509127.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180302221020.GA30722@lst.de>
 <CAPcyv4gKyvkHY_qQTYvd8wrLpaXXciJyWZY+9T7Q_Eg-Zuxpgw@mail.gmail.com>
 <20180302225734.GE31240@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 2 Mar 2018 15:49:45 -0800
Message-ID: <CAPcyv4jM=N=wjnK4gWxHu0Fk9VXnfReLf6shW6mbzvf3sahjrQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/12] vfio, dax: prevent long term filesystem-dax pins
 and other fixes
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
To: Christoph Hellwig <hch@lst.de>
Cc: Jane Chu <jane.chu@oracle.com>, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, KVM list <kvm@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Alex Williamson <alex.williamson@redhat.com>, Gerd Rausch <gerd.rausch@oracle.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 2, 2018 at 2:57 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Fri, Mar 02, 2018 at 02:21:40PM -0800, Dan Williams wrote:
>> They are indeed a hodge-podge. The problem is that the current
>> IS_DAX() is broken. So I'd like to propose fixing IS_DAX() with
>> IS_FSDAX() + IS_DEVDAX() for 4.16-rc4 and queue up these wider reworks
>> you propose for the next merge window.
>
> The only thing broken about IS_DAX are the code elimination games
> based on the CONFIG_* flags.  Remove those and just add proper stubs
> for the dax routines and everything will be fine for now until we can
> kill that inode flag.
>
> IS_FSDAX and IS_DEVDAX on the other hand are a giant mess that isn't
> helping anyone.

Ok, I'll take another shot at something suitable for 4.16, but without
these new helpers...
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
