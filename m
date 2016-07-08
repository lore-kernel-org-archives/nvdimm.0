Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 1C0FA1A1F92
 for <linux-nvdimm@lists.01.org>; Fri,  8 Jul 2016 10:27:08 -0700 (PDT)
Date: Sat, 9 Jul 2016 01:25:39 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 1/2] libnvdimm: add missing macros
Message-ID: <201607090117.yBNz7XdD%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <20160708162911.18756-1-eric.engestrom@imgtec.com>
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
To: Eric Engestrom <eric.engestrom@imgtec.com>
Cc: linux-nvdimm@lists.01.org, Eric Engestrom <eric@engestrom.ch>, linux-kernel@vger.kernel.org, kbuild-all@01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi,

[auto build test WARNING on linux-nvdimm/libnvdimm-for-next]
[also build test WARNING on v4.7-rc6 next-20160708]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Eric-Engestrom/libnvdimm-add-missing-macros/20160709-003310
base:   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git libnvdimm-for-next
config: x86_64-allmodconfig (attached as .config)
compiler: gcc-6 (Debian 6.1.1-1) 6.1.1 20160430
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All warnings (new ones prefixed by >>):

   In file included from drivers/dax/../nvdimm/nd.h:20:0,
                    from drivers/dax/pmem.c:18:
>> include/uapi/linux/ndctl.h:24:0: warning: "ARRAY_SIZE" redefined
    #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof(arr)[0])
    
   In file included from include/linux/percpu-refcount.h:49:0,
                    from drivers/dax/pmem.c:13:
   include/linux/kernel.h:54:0: note: this is the location of the previous definition
    #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
    

vim +/ARRAY_SIZE +24 include/uapi/linux/ndctl.h

     8	 * This program is distributed in the hope it will be useful, but WITHOUT ANY
     9	 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
    10	 * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
    11	 * more details.
    12	 */
    13	#ifndef __NDCTL_H__
    14	#define __NDCTL_H__
    15	
    16	#include <linux/types.h>
    17	
    18	#ifdef __GNUC__
    19	#define __packed __attribute__((packed))
    20	#else
    21	#define __packed
    22	#endif
    23	
  > 24	#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof(arr)[0])
    25	
    26	struct nd_cmd_smart {
    27		__u32 status;
    28		__u8 data[128];
    29	} __packed;
    30	
    31	#define ND_SMART_HEALTH_VALID	(1 << 0)
    32	#define ND_SMART_TEMP_VALID 	(1 << 1)

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
