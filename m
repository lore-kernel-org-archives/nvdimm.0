Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 916341A1DEE
 for <linux-nvdimm@lists.01.org>; Fri, 20 May 2016 17:51:19 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 0/2] bash completion for ndctl
Date: Fri, 20 May 2016 18:50:53 -0600
Message-Id: <1463791855-24615-1-git-send-email-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

ndctl dearly needed some bash completion goodness, so I decided to fix that.

The following kinds of completion are now supported:

$ ndctl 
create-namespace   disable-region     help               version            
destroy-namespace  enable-namespace   list               zero-labels        
disable-namespace  enable-region      read-labels        

$ ndctl create-namespace --
--bus=          --map=          --name=         --region=       --size=         --uuid=
--force         --mode=         --reconfig      --sector-size=  --type=         --verbose

$ ndctl create-namespace --region=region
region0  region1  region2  region3  region4  region5  region6  region7  region8  
$ ndctl create-namespace --region=region^C

$ ndctl disable-namespace 
all           namespace6.0  namespace7.0  namespace8.0  

$ ndctl read-labels 
all    nmem0  nmem1  nmem2  nmem3  nmem4  
$ ndctl read-labels ^C

$ ndctl --
--help       --list-cmds  --version    

$ ndctl list --namespaces --bus
--bus=   --buses  

$ ndctl list --namespaces --bus=nfit_test.
nfit_test.0  nfit_test.1  
$ ndctl list --namespaces --bus=nfit_test.

git/perf which this is based on has support for ZSH, so we *probably*
automatically get it, but I haven't tested it.

Go test it out!


Vishal Verma (2):
  ndctl: fix a segfault in parse-options.c
  ndctl: add bash completion

 Makefile.am          |   5 +
 configure.ac         |  17 +++
 contrib/ndctl        | 288 +++++++++++++++++++++++++++++++++++++++++++++++++++
 util/parse-options.c |   5 +-
 4 files changed, 313 insertions(+), 2 deletions(-)
 create mode 100755 contrib/ndctl

-- 
2.5.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
