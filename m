Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6727E21D0B65B
 for <linux-nvdimm@lists.01.org>; Mon, 17 Jul 2017 10:03:04 -0700 (PDT)
From: Linda Knippers <linda.knippers@hpe.com>
Subject: 'ndctl list' question
Message-ID: <596CEE1F.3060803@hpe.com>
Date: Mon, 17 Jul 2017 13:04:31 -0400
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

I have 8 NVDIMMs in my system and I have them configured in various ways.
When I run 'ndctl list', I get a nice simple summary of all of my devices.
What's missing though is the "chardev" information for my dax devices.

I do see that I can get it, and more, if I run 'ndctl list -X' but that
only gives me information about dax namespaces. I can also get it if I run
'daxctl list', but without any other useful information.  You can see all
the sample output below.

Is there a reason we can't have "chardev" in the output of 'ndctl list'
so that all the basic information is in one place?  I'm happy to do a
patch but since this has changed a bit (and I think the information
used to be there?), I thought I'd ask if there's a reason you omitted it.

Thanks,

-- ljk


$ ndctl list
[
  {
    "dev":"namespace1.0",
    "mode":"memory",
    "size":"8.00 GiB",
    "uuid":"322314b3-283b-40d9-a2fa-be73ff34b373",
    "blockdev":"pmem1",
    "numa_node":0
  },
  {
    "dev":"namespace3.0",
    "mode":"sector",
    "size":"7.99 GiB",
    "uuid":"df9992df-8d90-4017-be65-8166ab1fbe7e",
    "sector_size":4096,
    "blockdev":"pmem3s",
    "numa_node":0
  },
  {
    "dev":"namespace5.0",
    "mode":"raw",
    "size":"8.00 GiB",
    "blockdev":"pmem5",
    "numa_node":1
  },
  {
    "dev":"namespace7.0",
    "mode":"dax",
    "size":"7.87 GiB",
    "uuid":"c57b18aa-0c6a-4775-aa3e-e25f2a7c0c2f",
    "numa_node":1
  },
  {
    "dev":"namespace0.0",
    "mode":"memory",
    "size":"7.87 GiB",
    "uuid":"e5405210-373e-4604-94a2-4e42c73ecac0",
    "blockdev":"pmem0",
    "numa_node":0
  },
  {
    "dev":"namespace2.0",
    "mode":"memory",
    "size":"7.87 GiB",
    "uuid":"cd79114e-5f47-4b38-9511-fd130e0a34f4",
    "blockdev":"pmem2",
    "numa_node":0
  },
  {
    "dev":"namespace4.0",
    "mode":"dax",
    "size":"7.87 GiB",
    "uuid":"0c6c079b-57bb-48dd-9959-d2156f2f17ba",
    "numa_node":1
  },
  {
    "dev":"namespace6.0",
    "mode":"raw",
    "size":"8.00 GiB",
    "blockdev":"pmem6",
    "numa_node":1
  }
]

$ daxctl list
[
  {
    "chardev":"dax7.0",
    "size":"7.87 GiB"
  },
  {
    "chardev":"dax4.0",
    "size":"7.87 GiB"
  }
]

$ ndctl list -X
[
  {
    "dev":"namespace7.0",
    "mode":"dax",
    "size":"7.87 GiB",
    "uuid":"c57b18aa-0c6a-4775-aa3e-e25f2a7c0c2f",
    "daxregion":{
      "id":7,
      "size":"7.87 GiB",
      "align":4096,
      "devices":[
        {
          "chardev":"dax7.0",
          "size":"7.87 GiB"
        }
      ]
    },
    "numa_node":1
  },
  {
    "dev":"namespace4.0",
    "mode":"dax",
    "size":"7.87 GiB",
    "uuid":"0c6c079b-57bb-48dd-9959-d2156f2f17ba",
    "daxregion":{
      "id":4,
      "size":"7.87 GiB",
      "align":4096,
      "devices":[
        {
          "chardev":"dax4.0",
          "size":"7.87 GiB"
        }
      ]
    },
    "numa_node":1
  }
]
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
