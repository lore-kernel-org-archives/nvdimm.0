Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BF92121E2570E
 for <linux-nvdimm@lists.01.org>; Wed, 16 Aug 2017 08:17:50 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: ndctl oddity
Date: Wed, 16 Aug 2017 11:20:14 -0400
Message-ID: <x49378rh74h.fsf@segfault.boston.devel.redhat.com>
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
To: "Dan J. Williams" <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi, Dan,

If I create multiple namespaces in the same region, ndctl sometimes
outputs the wrong chardev for the newly created namespace.  I can
reproduce this fairly regularly.

Note how the chardev for the last two namespaces is the same.

# ndctl create-namespace -m dax -s 32G   
{
  "dev":"namespace4.0",
  "mode":"dax",
  "size":33820770304,
  "uuid":"368e4458-84a3-4593-a999-1febad5e6915",
  "daxregion":{
    "id":4,
    "size":33820770304,
    "align":2097152,
    "devices":[
      {
        "chardev":"dax4.0",
        "size":33820770304
      }
    ]
  }
}
# ndctl create-namespace -m dax -s 32G
{
  "dev":"namespace4.1",
  "mode":"dax",
  "size":33820770304,
  "uuid":"08c9ee03-6cd5-4333-8f94-341f63dd46d8",
  "daxregion":{
    "id":4,
    "size":33820770304,
    "align":2097152,
    "devices":[
      {
        "chardev":"dax4.1",
        "size":33820770304
      }
    ]
  }
}
# ndctl create-namespace -m dax -s 32G
{
  "dev":"namespace4.2",
  "mode":"dax",
  "size":33820770304,
  "uuid":"d5045fe4-0409-4278-8f8b-88ce608302d4",
  "daxregion":{
    "id":4,
    "size":33820770304,
    "align":2097152,
    "devices":[
      {
        "chardev":"dax4.1",
        "size":33820770304
      }
    ]
  }
}
# ls /dev/dax4*
/dev/dax4.0  /dev/dax4.1  /dev/dax4.2
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
