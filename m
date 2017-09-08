Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A1EBE20958BDA
 for <linux-nvdimm@lists.01.org>; Fri,  8 Sep 2017 01:27:52 -0700 (PDT)
Date: Fri, 8 Sep 2017 16:29:58 +0800
From: kbuild test robot <fengguang.wu@intel.com>
Subject: [linux-nvdimm:libnvdimm-for-next 22/22]
 include/linux/device.h:1441:2: note: in expansion of macro 'WARN_ONCE'
Message-ID: <201709081651.FfQfH2V0%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: kbuild-all@01.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git libnvdimm-for-next
head:   86652d2eb347080a991968c9d68708dc010ac56c
commit: 86652d2eb347080a991968c9d68708dc010ac56c [22/22] libnvdimm, btt: clean up warning and error messages
config: i386-randconfig-b0-09081531 (attached as .config)
compiler: gcc-5 (Debian 5.4.1-2) 5.4.1 20160904
reproduce:
        git checkout 86652d2eb347080a991968c9d68708dc010ac56c
        # save the attached .config to linux build tree
        make ARCH=i386 

All warnings (new ones prefixed by >>):

   In file included from arch/x86/include/asm/bug.h:81:0,
                    from include/linux/bug.h:4,
                    from include/linux/thread_info.h:11,
                    from arch/x86/include/asm/preempt.h:6,
                    from include/linux/preempt.h:80,
                    from include/linux/spinlock.h:50,
                    from include/linux/wait.h:8,
                    from include/linux/wait_bit.h:7,
                    from include/linux/fs.h:5,
                    from include/linux/highmem.h:4,
                    from drivers/nvdimm/btt.c:14:
   drivers/nvdimm/btt.c: In function 'btt_map_init':
>> include/linux/device.h:1441:23: warning: format '%lx' expects argument of type 'long unsigned int', but argument 4 has type 'size_t {aka unsigned int}' [-Wformat=]
     WARN_ONCE(condition, "%s %s: " format, \
                          ^
   include/asm-generic/bug.h:93:43: note: in definition of macro '__WARN_printf'
    #define __WARN_printf(arg...) do { printk(arg); __WARN(); } while (0)
                                              ^
   include/asm-generic/bug.h:149:3: note: in expansion of macro 'WARN'
      WARN(1, format);    \
      ^
>> include/linux/device.h:1441:2: note: in expansion of macro 'WARN_ONCE'
     WARN_ONCE(condition, "%s %s: " format, \
     ^
>> drivers/nvdimm/btt.c:430:3: note: in expansion of macro 'dev_WARN_ONCE'
      dev_WARN_ONCE(to_dev(arena), size < 512,
      ^
   drivers/nvdimm/btt.c: In function 'btt_log_init':
>> include/linux/device.h:1441:23: warning: format '%lx' expects argument of type 'long unsigned int', but argument 4 has type 'size_t {aka unsigned int}' [-Wformat=]
     WARN_ONCE(condition, "%s %s: " format, \
                          ^
   include/asm-generic/bug.h:93:43: note: in definition of macro '__WARN_printf'
    #define __WARN_printf(arg...) do { printk(arg); __WARN(); } while (0)
                                              ^
   include/asm-generic/bug.h:149:3: note: in expansion of macro 'WARN'
      WARN(1, format);    \
      ^
>> include/linux/device.h:1441:2: note: in expansion of macro 'WARN_ONCE'
     WARN_ONCE(condition, "%s %s: " format, \
     ^
   drivers/nvdimm/btt.c:474:3: note: in expansion of macro 'dev_WARN_ONCE'
      dev_WARN_ONCE(to_dev(arena), size < 512,
      ^
--
   In file included from arch/x86/include/asm/bug.h:81:0,
                    from include/linux/bug.h:4,
                    from include/linux/thread_info.h:11,
                    from arch/x86/include/asm/preempt.h:6,
                    from include/linux/preempt.h:80,
                    from include/linux/spinlock.h:50,
                    from include/linux/wait.h:8,
                    from include/linux/wait_bit.h:7,
                    from include/linux/fs.h:5,
                    from include/linux/highmem.h:4,
                    from drivers//nvdimm/btt.c:14:
   drivers//nvdimm/btt.c: In function 'btt_map_init':
>> include/linux/device.h:1441:23: warning: format '%lx' expects argument of type 'long unsigned int', but argument 4 has type 'size_t {aka unsigned int}' [-Wformat=]
     WARN_ONCE(condition, "%s %s: " format, \
                          ^
   include/asm-generic/bug.h:93:43: note: in definition of macro '__WARN_printf'
    #define __WARN_printf(arg...) do { printk(arg); __WARN(); } while (0)
                                              ^
   include/asm-generic/bug.h:149:3: note: in expansion of macro 'WARN'
      WARN(1, format);    \
      ^
>> include/linux/device.h:1441:2: note: in expansion of macro 'WARN_ONCE'
     WARN_ONCE(condition, "%s %s: " format, \
     ^
   drivers//nvdimm/btt.c:430:3: note: in expansion of macro 'dev_WARN_ONCE'
      dev_WARN_ONCE(to_dev(arena), size < 512,
      ^
   drivers//nvdimm/btt.c: In function 'btt_log_init':
>> include/linux/device.h:1441:23: warning: format '%lx' expects argument of type 'long unsigned int', but argument 4 has type 'size_t {aka unsigned int}' [-Wformat=]
     WARN_ONCE(condition, "%s %s: " format, \
                          ^
   include/asm-generic/bug.h:93:43: note: in definition of macro '__WARN_printf'
    #define __WARN_printf(arg...) do { printk(arg); __WARN(); } while (0)
                                              ^
   include/asm-generic/bug.h:149:3: note: in expansion of macro 'WARN'
      WARN(1, format);    \
      ^
>> include/linux/device.h:1441:2: note: in expansion of macro 'WARN_ONCE'
     WARN_ONCE(condition, "%s %s: " format, \
     ^
   drivers//nvdimm/btt.c:474:3: note: in expansion of macro 'dev_WARN_ONCE'
      dev_WARN_ONCE(to_dev(arena), size < 512,
      ^

vim +/WARN_ONCE +1441 include/linux/device.h

aebdc3b4 David Brownell   2007-07-12  1432  
e6139662 Arjan van de Ven 2008-09-20  1433  /*
3eae1367 Bjorn Helgaas    2013-10-24  1434   * dev_WARN*() acts like dev_printk(), but with the key difference of
3eae1367 Bjorn Helgaas    2013-10-24  1435   * using WARN/WARN_ONCE to include file/line information and a backtrace.
e6139662 Arjan van de Ven 2008-09-20  1436   */
e6139662 Arjan van de Ven 2008-09-20  1437  #define dev_WARN(dev, format, arg...) \
3eae1367 Bjorn Helgaas    2013-10-24  1438  	WARN(1, "%s %s: " format, dev_driver_string(dev), dev_name(dev), ## arg);
e6139662 Arjan van de Ven 2008-09-20  1439  
bcdd323b Felipe Balbi     2011-03-16  1440  #define dev_WARN_ONCE(dev, condition, format, arg...) \
3eae1367 Bjorn Helgaas    2013-10-24 @1441  	WARN_ONCE(condition, "%s %s: " format, \
3eae1367 Bjorn Helgaas    2013-10-24  1442  			dev_driver_string(dev), dev_name(dev), ## arg)
bcdd323b Felipe Balbi     2011-03-16  1443  

:::::: The code at line 1441 was first introduced by commit
:::::: 3eae13671716492f3bcde270115407185e9c69fd device: Make dev_WARN/dev_WARN_ONCE print device as well as driver name

:::::: TO: Bjorn Helgaas <bhelgaas@google.com>
:::::: CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
